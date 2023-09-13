//
//  Extensions.swift
//  hanaBankPokemonTCG
//
//  Created by Rendi Wijiatmoko on 13/09/23.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}
