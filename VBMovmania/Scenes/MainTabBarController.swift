//
//  ViewController.swift
//  VBMovmania
//
//  Created by Suheda on 12.07.2024.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        createTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func createTabBar() {
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let favoritesVC = UINavigationController(rootViewController: FavoritesViewController())
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        
        homeVC.tabBarItem.title = "Home"
        searchVC.tabBarItem.title = "Discover"
        favoritesVC.tabBarItem.title = "Favorites"
        settingsVC.tabBarItem.title = "Settings"
        tabBar.tintColor = .label
        
        homeVC.tabBarItem.image = UIImage(systemName: "play.house")
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        favoritesVC.tabBarItem.image = UIImage(systemName: "list.star")
        settingsVC.tabBarItem.image = UIImage(systemName: "gear")
        
        setViewControllers([homeVC, searchVC, favoritesVC, settingsVC], animated: true)
    }

}

