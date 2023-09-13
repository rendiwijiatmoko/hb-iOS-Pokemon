//
//  HBHomeVc.swift
//  hanaBankPokemonTCG
//
//  Created by Rendi Wijiatmoko on 13/09/23.
//

import UIKit

class HBHomeVc: UIViewController, CardListViewDelegate {
    
    private let cardListView = CardListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pokemon"
        setupUI()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        cardListView.delegate = self
        view.addSubview(cardListView)
        
        NSLayoutConstraint.activate([
            cardListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cardListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            cardListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            cardListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - CardListViewDelegate
    func hbCardListView(_ cardListView: CardListView, didSelectCard card: CardModel) {
        let viewModel = DetailPokemonVm(card: card)
        let detailVc = HBDetailPokemonVc(viewModel: viewModel)
        detailVc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVc, animated: true)
    }

}
