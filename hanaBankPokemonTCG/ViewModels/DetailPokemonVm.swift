//
//  DetailPokemonVm.swift
//  hanaBankPokemonTCG
//
//  Created by Rendi Wijiatmoko on 13/09/23.
//

import Foundation

final class DetailPokemonVm {
    private let pokemon: CardModel
    init(card: CardModel) {
        self.pokemon = card
    }
    
    public var title: String {
        pokemon.name?.uppercased() ?? ""
    }
}
