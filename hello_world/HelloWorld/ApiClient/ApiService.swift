//
//  ApiService.swift
//  TestPepe
//
//  Created by José De Jesús Vega López on 01/11/24.
//

import Foundation

class ApiService: NSObject {
    
    static let shared = ApiService()
    private let configuration: URLSessionConfiguration
    private let bearerToken = "" // auth token
    private lazy var session = URLSession(configuration: self.configuration)
    
    override init() {
        self.configuration = URLSessionConfiguration.default
        self.configuration.timeoutIntervalForRequest = 60
        self.configuration.timeoutIntervalForResource = 60
    }
    
    func request<T: Decodable>(_ requestModel: ApiRequestModel, _ modelType: T.Type) async throws -> T {
        guard
            let serviceUrl = URLComponents(string: BaseUrl.getUrl(with: requestModel.endpoint)),
            let url = serviceUrl.url
        else {
            throw NetworkingError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = requestModel.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        switch requestModel.header {
        case .Authorization:
            request.setValue(self.bearerToken, forHTTPHeaderField: "Authorization")
            
        case .noHeader: break // do nothing
        }
        if let parameters = requestModel.parameters {
            switch requestModel.encoding {
            case .url:
                var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
                let percentEncodedQuery = (urlComponents?.percentEncodedQuery.map { $0 + "&" } ?? "") + self.query(parameters)
                urlComponents?.percentEncodedQuery = percentEncodedQuery
                request.url = urlComponents?.url
                
            case .json:
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            }
        }
        let parameters = String(data: request.httpBody ?? Data(), encoding: .utf8)
        print("-------- REQUEST --------")
        print("METHOD: \(requestModel.method.rawValue)")
        print("HEADERS: \(request.allHTTPHeaderFields ?? ["":""])")
        print("URL: \(request.url?.absoluteString ?? "N/A")")
        print("BODY: \(parameters ?? "")")
        do {
            let (data, response) = try await self.session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkingError.httpResponseError
            }
            if httpResponse.statusCode == 200 {
                let decoder = JSONDecoder()
                let decodeData = try decoder.decode(T.self, from: data)
                print("-------- REPSONSE --------")
                print("\( String(data: data, encoding: .utf8) ?? "")")
                return decodeData
            }
            else if httpResponse.statusCode == 500 {
                throw NetworkingError.serverError
            }
            else {
                throw NetworkingError.generalError
            }
        }
        catch {
            if (error as? URLError)?.code == .timedOut {
                throw NetworkingError.timeOut
            }
            else if (error as? URLError)?.code == .networkConnectionLost {
                throw NetworkingError.connectionLost
            }
            throw NetworkingError.generalError
        }
    }
    
    func query(_ parameters: ParameterType) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += self.queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += self.queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        }
        else if let array = value as? [Any] {
            for value in array {
                components += self.queryComponents(fromKey: "\(key)[]", value: value)
            }
        }
        else if let value = value as? NSNumber {
            if value.isBool {
                components.append((self.escape(key), self.escape("\(value.boolValue)")))
            } else {
                components.append((self.escape(key), self.escape("\(value)")))
            }
        }
        else if let bool = value as? Bool {
            components.append((self.escape(key), self.escape("\(bool)")))
        }
        else {
            components.append((self.escape(key), self.escape("\(value)")))
        }
        return components
    }
    
    func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet: CharacterSet = .urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    }
}

// MARK: - Convenience checks
fileprivate extension NSNumber {
    var isBool: Bool { CFBooleanGetTypeID() == CFGetTypeID(self) }
}


