//
//  AttackCardCell.swift
//  hanaBankPokemonTCG
//
//  Created by Rendi Wijiatmoko on 14/09/23.
//

import UIKit

// Custom UICollectionViewCell for attack cards
class AttackCardCell: UICollectionViewCell {
    static let reuseIdentifier = "AttackCardCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let damageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        contentView.layer.cornerRadius = 8
        
        contentView.addSubviews(nameLabel, costLabel, damageLabel, textLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            costLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            costLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            damageLabel.topAnchor.constraint(equalTo: costLabel.bottomAnchor, constant: 4),
            damageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            textLabel.topAnchor.constraint(equalTo: damageLabel.bottomAnchor, constant: 4),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            textLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    func configure(with attack: Attack) {
        nameLabel.text = "Name: \(attack.name ?? "")"
        
        if let cost = attack.cost, !cost.isEmpty {
            costLabel.text = "Cost: \(cost.joined(separator: ", "))"
        } else {
            costLabel.text = "Cost: N/A"
        }
        
        damageLabel.text = "Damage: \(attack.damage ?? "")"
        textLabel.text = "\(attack.text ?? "")"
    }
}
