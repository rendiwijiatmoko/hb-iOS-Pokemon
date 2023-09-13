//
//  CardCollectionViewCellVm.swift
//  hanaBankPokemonTCG
//
//  Created by Rendi Wijiatmoko on 13/09/23.
//

import Foundation

final class CardCollectionViewCellVm: Hashable, Equatable  {
    
    public let cardName: String
    private let cardImageUrl: URL?
    
    static func == (lhs: CardCollectionViewCellVm, rhs: CardCollectionViewCellVm) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(cardName)
        hasher.combine(cardImageUrl)
    }
    
    // MARK: - init
    init(
        cardName: String,
        cardImageUrl: URL?
    ){
        self.cardName = cardName
        self.cardImageUrl = cardImageUrl
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        // TODO: Abstract to Image Manager
        guard let url = cardImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        HBImageLoader.shared.downloadImage(url, completion: completion)
    }
}
