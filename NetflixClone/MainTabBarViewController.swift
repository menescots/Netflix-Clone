//
//  ViewController.swift
//  NetflixClone
//
//  Created by Agata Menes on 03/02/2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: DownloadsViewController())
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "square.and.arrow.down")
        
        vc1.title = "Home"
        vc2.title = "Coming soon"
        vc3.title = "Search"
        vc4.title = "Downloads"
        tabBar.tintColor = .label
    }
    
}

