//
//  CardVm.swift
//  hanaBankPokemonTCG
//
//  Created by Rendi Wijiatmoko on 13/09/23.
//

import UIKit

protocol CardVmDelegate: AnyObject {
    func didLoadInitialCards()
    func didLoadMoreCardList(with newIndexPaths: [IndexPath])
    func didSelectCard(_ card: CardModel)
}

final class CardVm: NSObject {
    
    public weak var delegate: CardVmDelegate?
    private var isLoadingMoreCardList = false
    
    private var cards: [CardModel] = [] {
        didSet {
            for card in cards{
                let viewModel = CardCollectionViewCellVm(
                    cardName: card.name ?? "",
                    cardImageUrl: URL(string: card.images?.large ?? "")
                )
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [CardCollectionViewCellVm] = []
    private var page: Int?
    
    /// Fetch initial card list of pokemon
    public func fetchCardList() {
        let request = HBRequest(
            endPoint: .cards,
            queryParameters: [
                URLQueryItem(name: "pageSize", value: "8"),
            ]
        )
        HBService.shared.execute(request, expecting: ResponseModel.self) {[weak self] result in
            switch result {
            case .success(let responseModel):
                let data = responseModel.data
                self?.cards = data
                self?.page = responseModel.page
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCards()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    /// Paginate if card list of pokemon are needed
    public func fetchAdditionalCardList() {
        guard !isLoadingMoreCardList else { return }
        isLoadingMoreCardList = true
        let request = HBRequest(
            endPoint: .cards,
            queryParameters: [
                URLQueryItem(name: "pageSize", value: "8"),
                URLQueryItem(name: "page", value: "\((page ?? 1) + 1)"),
            ]
        )
        
        HBService.shared.execute(request, expecting: ResponseModel.self) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let responseModel):
                let moreData = responseModel.data
                strongSelf.page = responseModel.page
                let originalCount = strongSelf.cards.count
                let newCount = moreData.count
                let total = originalCount + newCount
                let startingIndex = total - newCount
                let indexPathsToAdd: [IndexPath] = Array(startingIndex ..< (startingIndex + newCount)).compactMap {
                    return IndexPath(row: $0, section: 0)
                }
                
                strongSelf.cards.append(contentsOf: moreData)
                
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreCardList(with: indexPathsToAdd)
                    strongSelf.isLoadingMoreCardList = false
                }
            case .failure(let error):
                strongSelf.isLoadingMoreCardList = false
                print("Error: \(error)")
            }
        }
    }

    
    public var shouldShowLoadMoreIndicator: Bool {
        return page != (250/8) // 250 is the max pokemon and 8 is the amount for the pokemon each list
    }
}

// MARK: - CollectionView
extension CardVm: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.cellIdentifier, for: indexPath) as? CardCollectionViewCell else {fatalError("Unsupported cell")}
        //                let viewModel = CardCollectionViewCellVm(
        //                    cardName: "Pikacu",
        //                    cardSupertype: "Pokemon",
        //                    cardImageUrl: URL(string: "https://images.pokemontcg.io/hgss4/1_hires.png")
        //                )
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter, let footer  = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: FooterLoadingCollectionReusableView.indicator,
            for: indexPath
        ) as? FooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        return CGSize(
            width: width,
            height: width*1.5
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let card = cards[indexPath.row]
        delegate?.didSelectCard(card)
    }
}

// MARK: - ScrollView
extension CardVm: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreCardList,
              !cellViewModels.isEmpty
        else {
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) {[weak self ] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.fetchAdditionalCardList()
            }
            t.invalidate()
        }
    }
}
