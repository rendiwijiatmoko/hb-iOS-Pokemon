//
//  HBTabBarVC.swift
//  hanaBankPokemonTCG
//
//  Created by Rendi Wijiatmoko on 13/09/23.
//

import UIKit

class HBTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpTabs()
    }
    
    private func setUpTabs() {
           let homeVc = HBHomeVc()
           let searchVc = HBSearchVc()
           
           homeVc.navigationItem.largeTitleDisplayMode = .automatic
           searchVc.navigationItem.largeTitleDisplayMode = .automatic
           
           let nav1 = UINavigationController(rootViewController: homeVc)
           let nav2 = UINavigationController(rootViewController: searchVc)
           
           nav1.tabBarItem = UITabBarItem(
               title: "Pokemon",
               image: UIImage(systemName: "house"),
               tag: 1)
           nav2.tabBarItem = UITabBarItem(
               title: "Search",
               image: UIImage(systemName: "magnifyingglass"),
               tag: 2)
           
           for nav in [nav1, nav2] {
               nav.navigationBar.prefersLargeTitles = true
           }
           
           setViewControllers(
               [nav1, nav2],
               animated: true)
       }
}
