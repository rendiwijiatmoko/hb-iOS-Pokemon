//
//  SearchVm.swift
//  hanaBankPokemonTCG
//
//  Created by Rendi Wijiatmoko on 14/09/23.
//

import UIKit

protocol SearchVmDelegate: AnyObject {
    func didLoadInitialCards()
    func hbCardListView(
//        _ cardListView: CardListView,
        didSelectCard card: CardModel
    )
}

final class SearchVm: NSObject {
    
    public weak var delegate: SearchVmDelegate?
    
    private var cards: [CardModel] = [] {
        didSet {
            for card in cards{
                let viewModel = SearchCellVm(
                    cardName: card.name ?? "",
                    artist: card.artist ?? "",
                    cardImageUrl: URL(string: card.images?.small ?? "")
                )
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [SearchCellVm] = []
    
    private var queryParameters: [URLQueryItem] = [
        URLQueryItem(name: "pageSize", value: "32"),
    ]
    
    public func updateQueryParameters(_ searchQuery: String) {
        queryParameters.removeAll()
        queryParameters.append(URLQueryItem(name: "pageSize", value: "32"))
        if !searchQuery.isEmpty {
            queryParameters.append(URLQueryItem(name: "q", value: "name:\(searchQuery)*"))
        }
        
        let request = HBRequest(
            endPoint: .cards,
            queryParameters: queryParameters
        )
        
        HBService.shared.execute(request, expecting: ResponseModel.self) {[weak self] result in
            switch result {
            case .success(let responseModel):
                let data = responseModel.data
                self?.cards = data
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCards()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}


extension SearchVm: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.cellIdentifier, for: indexPath) as? SearchTableViewCell else {fatalError("Unsupported")}
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.hbCardListView(didSelectCard: cards[indexPath.row])
    }
    
}
