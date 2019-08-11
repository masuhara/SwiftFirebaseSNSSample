//
//  UserModel.swift
//  FirebaseSNSSample
//
//  Created by Masuhara on 2019/07/06.
//  Copyright © 2019 Ylab Inc. All rights reserved.
//

import UIKit
import FirebaseAuth

// ユーザーを扱いやすくするモデルクラス(設計図)を作成
struct UserModel {
    
    // ユーザーの設計
    var uid: String! // 各ユーザーごとの固有のID
    var email: String? // メールアドレス
    var displayName: String? // 表示名
    var photoURL: URL? // 画像のURL
    
    // ログイン中のユーザーを取得するメソッド
    static func currentUser() -> UserModel? {
        if let currentUser = Auth.auth().currentUser {
            var user = UserModel()
            user.uid = currentUser.uid
            user.email = currentUser.email
            user.displayName = currentUser.displayName
            user.photoURL = currentUser.photoURL
            return user
        } else {
            return nil
        }
    }
    
    // ログイン中のユーザーがいるかどうか確認し、ログインしていなければログイン画面に飛ばすメソッド
    static func validateCurrentUser() {
        if let _ = UserModel.currentUser() {
            SegueManager.show(displayType: .main)
        } else {
            SegueManager.show(displayType: .login)
        }
    }
    
    // 会員登録
    static func signUp(email: String, password: String, completion: @escaping(Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            completion(error)
        }
    }
    
    // ログイン
    static func login(email: String, password: String, completion: @escaping(Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            completion(error)
        }
    }
    
    // ログアウト
    static func logout(completion: @escaping(Error?) -> ()) {
        do {
            try Auth.auth().signOut()
        } catch let error {
            completion(error)
        }
    }
    
}
