//
//  CardModel.swift
//  hanaBankPokemonTCG
//
//  Created by Rendi Wijiatmoko on 13/09/23.
//

import Foundation

// MARK: - CardModel
struct CardModel: Codable {
    let id, name, supertype: String?
    let subtypes: [String]?
    let hp: String?
    let types: [String]?
    let evolvesFrom: String?
    let attacks: [Attack]?
    let weaknesses, resistances: [Resistance]?
    let retreatCost: [String]?
    let convertedRetreatCost: Int?
    let cardModelSet: SetModel?
    let number, artist, rarity, flavorText: String?
    let nationalPokedexNumbers: [Int]?
    let legalities: Legalities?
    let images: CardModelImages?
    let tcgplayer: Tcgplayer?
    let cardmarket: Cardmarket?

    enum CodingKeys: String, CodingKey {
        case id, name, supertype, subtypes, hp, types, evolvesFrom, attacks, weaknesses, resistances, retreatCost, convertedRetreatCost
        case cardModelSet = "set"
        case number, artist, rarity, flavorText, nationalPokedexNumbers, legalities, images, tcgplayer, cardmarket
    }
}

// MARK: - Attack
struct Attack: Codable {
    let name: String?
    let cost: [String]?
    let convertedEnergyCost: Int?
    let damage, text: String?
}

// MARK: - Set
struct SetModel: Codable {
    let id, name, series: String?
    let printedTotal, total: Int?
    let legalities: Legalities?
    let ptcgoCode, releaseDate, updatedAt: String?
    let images: SetImages?
}

// MARK: - SetImages
struct SetImages: Codable {
    let symbol, logo: String?
}

// MARK: - Legalities
struct Legalities: Codable {
    let unlimited: String?
}

// MARK: - Cardmarket
struct Cardmarket: Codable {
    let url: String?
    let updatedAt: String?
    let prices: [String: Double]?
}

// MARK: - CardModelImages
struct CardModelImages: Codable {
    let small, large: String?
}

// MARK: - Resistance
struct Resistance: Codable {
    let type, value: String?
}

// MARK: - Tcgplayer
struct Tcgplayer: Codable {
    let url: String?
    let updatedAt: String?
    let prices: Prices?
}

// MARK: - Prices
struct Prices: Codable {
    let holofoil, reverseHolofoil: Holofoil?
}

// MARK: - Holofoil
struct Holofoil: Codable {
    let low, mid, high, market: Double?
    let directLow: Double?
}
