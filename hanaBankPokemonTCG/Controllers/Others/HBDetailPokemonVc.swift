//
//  HBDetailPokemonVc.swift
//  hanaBankPokemonTCG
//
//  Created by Rendi Wijiatmoko on 13/09/23.
//

import UIKit

/// Controller to show info detail pokemon from card list
final class HBDetailPokemonVc: UIViewController {

    private let viewModel: DetailPokemonVm
    
    init(viewModel: DetailPokemonVm) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
    }
}
