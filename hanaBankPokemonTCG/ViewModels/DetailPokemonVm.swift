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
    
    public var name: String {
        pokemon.name ?? ""
    }
    
    public var types: [String] {
        pokemon.types ?? []
    }
    
    public var hp: String {
        pokemon.hp ?? ""
    }
    
    public var weaknesses: [(type: String, value: String)] {
        return pokemon.weaknesses?.compactMap { weakness in
            if let type = weakness.type, let value = weakness.value {
                return (type: type, value: value)
            }
            return nil
        } ?? []
    }
    
    public var resistances: [(type: String, value: String)] {
        return pokemon.resistances?.compactMap { resistance in
            if let type = resistance.type, let value = resistance.value {
                return (type: type, value: value)
            }
            return nil
        } ?? []
    }
    
    public var attacks: [Attack] {
        return pokemon.attacks?.compactMap { attack in
            if let name = attack.name,
                let cost = attack.cost,
                let damage = attack.damage,
                let text = attack.text,
                let convertedEnergyCost = attack.convertedEnergyCost
            {
                return Attack(name: name, cost: cost, convertedEnergyCost: convertedEnergyCost, damage: damage, text: text)
            }
            return nil
        } ?? []
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: pokemon.images?.large ?? "") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        HBImageLoader.shared.downloadImage(url, completion: completion)
    }
}
