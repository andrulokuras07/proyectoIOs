//
//  GetPokemon.swift
//  HelloWorld
//
//  Created by Alumnos on 22/04/26.
//

struct GetPokemon: Codable {
    var count: Double?
    var next: String?
    var previous: String?
    var results: [Pokemon]?
    
    struct Pokemon: Codable {
        var name: String?
        var url: String?
    }
}
