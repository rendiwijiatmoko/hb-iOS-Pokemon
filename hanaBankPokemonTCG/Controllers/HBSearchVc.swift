//
//  HBSearchVc.swift
//  hanaBankPokemonTCG
//
//  Created by Rendi Wijiatmoko on 13/09/23.
//

import UIKit

class HBSearchVc: UIViewController, UISearchBarDelegate {
    
    private let viewModel = SearchVm()
    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        searchBar.delegate = self
        searchBar.placeholder = "Search name, types, evolvesFrom"
        navigationItem.titleView = searchBar
        viewModel.delegate = self
        
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
        
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.cellIdentifier)
    }
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        
        viewModel.updateQueryParameters(searchText)
        searchBar.resignFirstResponder()
    }

}

extension HBSearchVc: SearchVmDelegate{
    func hbCardListView(didSelectCard card: CardModel) {
        let viewModel = DetailPokemonVm(card: card)
        let detailVc = HBDetailPokemonVc(viewModel: viewModel)
        detailVc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVc, animated: true)
    }
    func didLoadInitialCards() {
        tableView.reloadData()
    }
    
}
