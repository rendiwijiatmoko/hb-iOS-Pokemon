//
//  DetailPokemonView.swift
//  hanaBankPokemonTCG
//
//  Created by Rendi Wijiatmoko on 13/09/23.
//

import UIKit

/// single view to show detail pokemon
final class DetailPokemonView: UIView, UICollectionViewDataSource {
    
    // MARK: - Properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let hpLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weaknessLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let resistanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let attackLabel: UILabel = {
        let label = UILabel()
        label.text = "Attack"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let attacksCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewCompositionalLayout { (section, environment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 8
            
            return section
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var attacks: [Attack] = []
    private var viewModel: DetailPokemonVm
    
    // MARK: - init
    init(frame: CGRect, viewModel: DetailPokemonVm) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        attacks = viewModel.attacks
        addSubviews(imageView, typeLabel, hpLabel, weaknessLabel, resistanceLabel, attackLabel, attacksCollectionView)
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            
            typeLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            typeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            hpLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 8),
            hpLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            weaknessLabel.topAnchor.constraint(equalTo: hpLabel.bottomAnchor, constant: 8),
            weaknessLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            resistanceLabel.topAnchor.constraint(equalTo: weaknessLabel.bottomAnchor, constant: 8),
            resistanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            attackLabel.topAnchor.constraint(equalTo: resistanceLabel.bottomAnchor, constant: 8),
            attackLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            attacksCollectionView.topAnchor.constraint(equalTo: attackLabel.bottomAnchor, constant: 16),
            attacksCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            attacksCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            attacksCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
        
        nameLabel.text = "Name: \(viewModel.name)"
        typeLabel.text = "Type: \(viewModel.types.joined(separator: ", "))"
        hpLabel.text = "HP: \(viewModel.hp)"
        
        if !viewModel.weaknesses.isEmpty {
            let weakness = viewModel.weaknesses[0]
            weaknessLabel.text = "Weakness: \(weakness.type) (\(weakness.value))"
        } else {
            weaknessLabel.text = "Weakness: None"
        }
        
        if !viewModel.resistances.isEmpty {
            let resistance = viewModel.resistances[0]
            resistanceLabel.text = "Resistance: \(resistance.type) (\(resistance.value))"
        } else {
            resistanceLabel.text = "Resistance: None"
        }
        
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
        
        attacksCollectionView.register(AttackCardCell.self, forCellWithReuseIdentifier: AttackCardCell.reuseIdentifier)
        attacksCollectionView.dataSource = self
    }
    
    // UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attacks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttackCardCell.reuseIdentifier, for: indexPath) as! AttackCardCell
        let attack = attacks[indexPath.item]
        cell.configure(with: attack)
        return cell
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
}
