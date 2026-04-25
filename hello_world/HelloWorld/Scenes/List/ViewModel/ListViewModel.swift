//
//  ListViewModel.swift
//  HelloWorldJdJVL
//
//  Created by José De Jesús Vega López on 21/04/26.
//

import Foundation

class ListViewModel {
    // MARK: - PRIVATE PROPERTIES
    private var model: ListModel
    private let repository: any ListRepositoryProtocol
    
    // MARK: - INIT
    init() {
        self.model = ListModel()
        self.repository = ListRepository()
    }
    
    // MARK: - PUBLIC PROPERTIES
    var pokemonList: [GetPokemon.Pokemon] {
        get { model.pokemons }
        set { model.pokemons = newValue }
    }
    
    var hasContent: Bool  {
        !pokemonList.isEmpty
    }
    
    func getPokemonList() async throws {
        let response = try await repository.getPokemons()
        // Aditional validation
        pokemonList = response
    }
    
}
