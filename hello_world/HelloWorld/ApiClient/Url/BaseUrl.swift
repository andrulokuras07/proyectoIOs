//
//  BaseUrl.swift
//  TestPepe
//
//  Created by José De Jesús Vega López on 01/11/24.
//

import Foundation

struct BaseUrl {
    static func getBaseUrl() -> String {
        do {
            // get from x configuration file for configure enviroments [dev|pro|qa]
            let url: String = "https://pokeapi.co/api/v2/"
            return url
        }
        catch {
            fatalError("review configuration variables")
        }
    }
    
    static func getUrl(with endpoint: Endpoint) -> String {
        let url = self.getBaseUrl()
        return url + endpoint.rawValue
    }
}
