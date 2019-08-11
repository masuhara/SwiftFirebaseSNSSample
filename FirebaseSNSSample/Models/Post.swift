//
//  Post.swift
//  FirebaseSNSSample
//
//  Created by Masuhara on 2019/07/07.
//  Copyright © 2019 Ylab Inc. All rights reserved.
//

import UIKit
import Firebase

struct Post {
    // 1つの投稿の設計
    var uid: String! // 投稿ごとのユニークなID
    var userId: String! // 投稿したユーザーのID
    var photoURL: String! // 投稿した写真のURL
    var createdAt: String! // 投稿した日時
    
    var text: String? // 投稿に付加したテキスト
    var favoriteUsers: [String]? // 投稿にいいねしたユーザーId一覧
    var comments: [Comment]? // 投稿へのコメント一覧
    
    // 投稿をDBに保存
    func save(completion: @escaping(Error?) -> ()) {
        // ログインしているユーザー、テキストの記入、写真の設定がない場合、投稿できずreturnするようにしている
        guard let userId = UserModel.currentUser()?.uid else { return }
        guard let text = self.text else { return }
        guard let photoURL = self.photoURL else { return }
        
        // Firestoreのデータベースを取得
        let db = Firestore.firestore()
        
        // データベースのpostsパスに対して投稿データを追加し保存
        db.collection("posts").addDocument(data: [
            "text": text,
            "photoURL": photoURL,
            "userId": userId,
            "createdAt": String(Date().timeIntervalSince1970)
        ]) { error in
            // 処理が終了したらcompletionブロックにerrorを返す.errorがnilなら成功
            completion(error)
        }
    }
    
    // DBから投稿を取得
    static func getAll(isAdditional: Bool = false, lastSnapshot: DocumentSnapshot? = nil, completion: @escaping(_ posts: [Post]?, _ lastSnapshot: DocumentSnapshot?, _ error: Error?) -> ()) {
        // データベースへの参照を作る
        let ref = Firestore.firestore().collection("posts")
        
        // タイムラインは新しい投稿が上にくるので降順にし、50件ずつ取得するクエリを作成
        var query = ref.order(by: "createdAt", descending: true).limit(to: 50)
        
        // 下に引っ張って読み込み(追加読み込み)の操作のときは、前回読み込んだ最後の投稿を基準に読み込むクエリを作成
        if isAdditional == true {
            guard let lastSnapshot = lastSnapshot else {
                completion(nil, nil, nil)
                return
            }
            query = query.start(afterDocument: lastSnapshot)
        }
        
        // クエリの読み込み
        query.getDocuments { (snapshot, error) in
            if let error = error {
                // 取得時にエラーが発生した場合errorをcompletionブロックに返す
                completion(nil, nil, error)
            } else {
                // 読み込んだsnapshotのデータをPostクラスの配列に変換
                if let documents = snapshot?.documents {
                    var posts = [Post]()
                    for document in documents {
                        let data = document.data()
                        var post = Post()
                        post.uid = document.documentID
                        post.userId = data["userId"] as? String
                        post.photoURL = data["photoURL"] as? String
                        post.text = data["text"] as? String
                        post.createdAt = data["createdAt"] as? String
                        post.favoriteUsers = data["favoriteUsers"] as? [String]
                        posts.append(post)
                    }
                    
                    // 追加読み込みのため、1度読み込んだらその最後の投稿データを変数に格納しておく
                    let lastSnapshot = documents.last
                    
                    // 処理完了とともにPostクラスの配列と最後の投稿データをcompletionブロックに返す
                    completion(posts, lastSnapshot, nil)
                } else {
                    // エラーもないが取得できるsnapshotがなかった場合
                    completion(nil, nil, nil)
                }
            }
        }
    }
    
    func favorite(completion: @escaping(Error?) -> ()) {
        guard let userId = UserModel.currentUser()?.uid else { return }
        if self.favoriteUsers?.contains(userId) == true {
            // いいねを解除
            guard let postId = self.uid else { return }
            guard let currentUserId = UserModel.currentUser()?.uid else { return }
            let db = Firestore.firestore()
            db.document("posts/\(postId)").updateData(["favoriteUsers": FieldValue.arrayRemove([currentUserId])]) { (error) in
                completion(error)
            }
        } else {
            // いいね
            guard let postId = self.uid else { return }
            guard let currentUserId = UserModel.currentUser()?.uid else { return }
            let db = Firestore.firestore()
            db.document("posts/\(postId)").updateData(["favoriteUsers": [currentUserId]]) { (error) in
                completion(error)
            }
        }
        
    }
}
