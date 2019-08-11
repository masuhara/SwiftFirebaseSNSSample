//
//  SegueManager.swift
//  FirebaseSNSSample
//
//  Created by Masuhara on 2019/07/06.
//  Copyright © 2019 Ylab Inc. All rights reserved.
//

import UIKit

// Storyboard間をまたいで遷移する場合に簡単に遷移できるようにするマネージャー
struct SegueManager {
    
    // 遷移する画面を変数のように選べるenum(列挙型)
    enum DisplayType {
        case login
        case main
        // case walkThrough
    }
    
    // 引数に選ばれた画面を表示させるメソッド
    static func show(displayType: DisplayType) {
        // アプリ全体のウィンドウを取得
        let appDelegate = UIApplication.shared.delegate
        guard let keyWindow = appDelegate?.window else { return }
        
        // 引数で選ばれた画面によって遷移
        switch displayType {
        case .login:
            // ログイン画面のStoryboardを取得してウィンドウを差し替え
            let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
            let loginViewController = storyboard.instantiateInitialViewController() as! UINavigationController
            keyWindow?.rootViewController = loginViewController
        case .main:
            // MainのStoryboardを取得してウィンドウを差し替え
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let rootTabBarController = storyboard.instantiateInitialViewController() as! RootTabBarController
            keyWindow?.rootViewController = rootTabBarController
        }
    }
}
