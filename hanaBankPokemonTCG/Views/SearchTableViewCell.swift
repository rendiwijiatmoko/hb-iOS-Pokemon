//
//  SearchTableViewCell.swift
//  hanaBankPokemonTCG
//
//  Created by Rendi Wijiatmoko on 14/09/23.
//

import UIKit

protocol SearchTableViewCellDelegate: AnyObject {
    func hbCardListView(
        _ cardListView: CardListView,
        didSelectCard card: CardModel
    )
}

class SearchTableViewCell: UITableViewCell {
    static let cellIdentifier = "SearchTableViewCell"
    
    private let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews(customImageView, titleLabel)

        NSLayoutConstraint.activate([
            customImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            customImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            customImageView.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            customImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
            customImageView.widthAnchor.constraint(equalToConstant: 50),
            customImageView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.leadingAnchor.constraint(equalTo: customImageView.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    public func configure(with viewModel: SearchCellVm) {
        titleLabel.text = "\(viewModel.cardName) | \(viewModel.artist)"
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.customImageView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

