//
//  TabBarController.swift
//  LFShimmer
//
//  Created by Florian LUDOT on 6/29/18.
//  Copyright © 2018 Florian LUDOT. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViewControllers()
    }
    
    private func setupChildViewControllers() {
        let feedViewController = FeedViewController()
        
        setupTabBarItem(viewController: feedViewController, image: #imageLiteral(resourceName: "tab_feed_s"), tag: 0, title: "Feed")


        
        let feedNavigationViewController = UINavigationController(rootViewController: feedViewController)
        
        self.viewControllers = [feedNavigationViewController]
    }
    
    private func setupTabBarItem(viewController: UIViewController, image: UIImage, tag: Int, title: String) {
        viewController.tabBarItem.image = image
        viewController.tabBarItem.tag = tag
        viewController.title = title
        viewController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
        viewController.tabBarItem.imageInsets = UIEdgeInsets(top: -2, left: 0, bottom: 0, right: 0)
    }
    
}
