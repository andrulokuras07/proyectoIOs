//
//  ListRepository.swift
//  HelloWorldJdJVL
//
//  Created by José De Jesús Vega López on 21/04/26.
//


protocol ListRepositoryProtocol {
    func getPokemons() async throws -> [GetPokemon.Pokemon]
    func getPokemons(_ request: [String:Any]) async throws -> String // EXAMPLE WITH REQUEST
}

actor ListRepository: ListRepositoryProtocol {
    func getPokemons() async throws -> [GetPokemon.Pokemon] {
        let request = ApiRequestModel(
            endpoint: .GET_POKEMONS,
            method: .get,
            header: .Authorization,
            encoding: .url,
            parameters: nil
        )
        let response = try await ApiService.shared.request(
            request,
            GetPokemon.self
        )
        return response.results ?? []
    }
    
    // EXAMPLE WITH PARAMS
    func getPokemons(_ request: [String:Any]) async throws -> String {
        let request = ApiRequestModel(
            endpoint: .GET_POKEMONS,
            method: .get,
            header: .Authorization,
            encoding: .url,
            parameters: request
        )
        let response = try await ApiService.shared.request(
            request,
            String.self
        )
        return response
    }

    
}
