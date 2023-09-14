//
//  SearchCellVm.swift
//  hanaBankPokemonTCG
//
//  Created by Rendi Wijiatmoko on 14/09/23.
//

import Foundation


final class SearchCellVm: Hashable, Equatable  {
    
    public let cardName: String
    public let artist: String
    private let cardImageUrl: URL?
    
    static func == (lhs: SearchCellVm, rhs: SearchCellVm) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(cardName)
        hasher.combine(artist)
        hasher.combine(cardImageUrl)
    }
    
    // MARK: - init
    init(
        cardName: String,
        artist: String,
        cardImageUrl: URL?
    ){
        self.cardName = cardName
        self.artist = artist
        self.cardImageUrl = cardImageUrl
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = cardImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        HBImageLoader.shared.downloadImage(url, completion: completion)
    }
}
