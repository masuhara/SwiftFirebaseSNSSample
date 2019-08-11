//
//  RootTabBarController.swift
//  FirebaseSNSSample
//
//  Created by Masuhara on 2019/07/06.
//  Copyright © 2019 Ylab Inc. All rights reserved.
//

import UIKit
import FontAwesome_swift

class RootTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    func configureTabBar() {
        tabBar.items![0].image = UIImage.fontAwesomeIcon(name: .home, style: .solid, textColor: .blue, size: CGSize(width: 25.0, height: 25.0)).withRenderingMode(.automatic)
        tabBar.items![1].image = UIImage.fontAwesomeIcon(name: .user, style: .solid, textColor: .blue, size: CGSize(width: 25.0, height: 25.0)).withRenderingMode(.automatic)
    }

}
