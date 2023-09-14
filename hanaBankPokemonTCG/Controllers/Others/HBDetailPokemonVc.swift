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
    
    private let detailView: DetailPokemonView
    
    // MARK: - init
    init(viewModel: DetailPokemonVm) {
        self.viewModel = viewModel
        self.detailView = DetailPokemonView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.name
        view.addSubview(detailView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
        setupUI()
    }
    
    @objc
    private func didTapShare(){
        print("url for link of pokemon")
    }
    
    // MARK: - setup UI
    private func setupUI(){
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
