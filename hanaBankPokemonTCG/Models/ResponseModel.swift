//
//  ResponseModel.swift
//  hanaBankPokemonTCG
//
//  Created by Rendi Wijiatmoko on 13/09/23.
//

import Foundation

struct ResponseModel: Codable {
      let data: [CardModel]
      let page, pageSize, count, totalCount: Int
}
