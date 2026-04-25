//
//  ApiRequestModel.swift
//  TestPepe
//
//  Created by José De Jesús Vega López on 01/11/24.
//

import Foundation

struct ApiRequestModel {
    let endpoint: Endpoint
    let method: HTTPMethod
    let header: Header
    let encoding: Encoding
    let parameters: ParameterType?
}
