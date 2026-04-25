//
//  ApiErrors.swift
//  TestPepe
//
//  Created by José De Jesús Vega López on 01/11/24.
//

import Foundation

enum NetworkingError: Error {
    case customError(msg: String)
    case generalError
    case invalidURL
    case timeOut
    case connectionLost
    case httpResponseError
    case serverError
}

extension NetworkingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .customError(let msg): return NSLocalizedString(msg, comment: "")
        case .generalError: return NSLocalizedString("API Error: General Error", comment: "")
        case .invalidURL: return NSLocalizedString("API Error: URL is invalid", comment: "")
        case .timeOut: return NSLocalizedString("This request has timed out.", comment: "")
        case .connectionLost: return NSLocalizedString("Se perdió la conexión de red", comment: "")
        case .httpResponseError: return NSLocalizedString("Api Error: httpResponseError", comment: "")
        case .serverError: return NSLocalizedString("Api Error: Server Error", comment: "")
        }
    }
}
