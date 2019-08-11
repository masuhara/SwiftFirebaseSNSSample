//
//  TimelineViewController.swift
//  FirebaseSNSSample
//
//  Created by Masuhara on 2019/07/06.
//  Copyright © 2019 Ylab Inc. All rights reserved.
//

import UIKit
import Firebase
import KafkaRefresh
import DZNEmptyDataSet
import SkeletonView
import Kingfisher
import SwiftMessages
import FontAwesome_swift

class TimelineViewController: UIViewController {
    
    // メインのライムラインを形成するテーブルビュー
    @IBOutlet weak var timelineTableView: UITableView!
    
    // 投稿を入れておく配列
    var posts = [Post]()
    
    // 読み込み中かどうかを判別する変数(読み込み結果が0件の場合DZNEmptyDataSetで空の表示をさせるため)
    var isLoading: Bool = false
    
    // 下に引っ張って追加読み込みしたい場合に使う、読み込んだ投稿の最後の投稿を保存する変数
    var lastSnapshot: DocumentSnapshot?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        loadTimeline()
    }
    
    // テーブルビューの細かい設定
    func configureTableView() {
        timelineTableView.dataSource = self
        timelineTableView.delegate = self
        
        // 読み込み結果が0件だったときの表示設定
        timelineTableView.emptyDataSetSource = self
        timelineTableView.emptyDataSetDelegate = self
        
        // 不要な区切り線を消す
        timelineTableView.tableFooterView = UIView()
        
        // セルをコメントの長さに合わせて高さを可変にする
        timelineTableView.rowHeight = UITableView.automaticDimension
        timelineTableView.estimatedRowHeight = 44.0
        
        // カスタムセルの登録
        let nib = UINib(nibName: "PostTableViewCell", bundle: Bundle.main)
        timelineTableView.register(nib, forCellReuseIdentifier: "PostTableViewCell")
        
        // 引っ張って更新(上)
        timelineTableView.bindHeadRefreshHandler({
            self.loadTimeline()
        }, themeColor: .lightGray, refreshStyle: .native)
        
        // 引っ張って追加読み込み(下)
        timelineTableView.bindFootRefreshHandler({
            self.loadTimeline(isAdditional: true)
        }, themeColor: .lightGray, refreshStyle: .native)
    }
    
    // タイムラインの読み込み(引数をとくに渡さなければ最新のものをDBから取得)
    func loadTimeline(isAdditional: Bool = false) {
        isLoading = true
        Post.getAll(isAdditional: isAdditional, lastSnapshot: lastSnapshot) { (posts, lastSnapshot, error) in
            // 読み込み完了
            self.isLoading = false
            self.lastSnapshot = lastSnapshot
            self.timelineTableView.headRefreshControl.endRefreshing()
            self.timelineTableView.footRefreshControl.endRefreshing()
            
            if let error = error {
                // エラー処理
                self.showError(error: error)
            } else {
                // 読み込みが成功した場合
                if let posts = posts {
                    // 追加読み込みなら配列に追加、そうでないなら配列に再代入
                    if isAdditional == true {
                        self.posts = self.posts + posts
                    } else {
                        self.posts = posts
                    }
                    self.timelineTableView.reloadData()
                }
            }
        }
    }
    
    // 投稿ボタン(右下)が押されたとき、新規投稿画面に遷移
    @IBAction func addPost() {
        self.performSegue(withIdentifier: "toPost", sender: nil)
    }

    // エラー表示用
    func showError(error: Error? = nil) {
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(.error)
        view.button?.isHidden = true
        view.titleLabel?.text = "Error"
        view.bodyLabel?.text = error?.localizedDescription
        SwiftMessages.show(view: view)
    }
}

extension TimelineViewController: PostTableViewCellDelegate {
    func didTapFavoriteButton(button: UIButton, cell: UITableViewCell) {
        self.posts[button.tag].favorite { (error) in
            if let error = error {
                print("error === " + error.localizedDescription)
            } else {
                self.loadTimeline()
            }
        }
    }
    
    func didTapCommentButton(button: UIButton, cell: UITableViewCell) {
        
    }
}

extension TimelineViewController: UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        cell.delegate = self
        cell.favoriteButton.tag = indexPath.row
        cell.commentButton.tag = indexPath.row
        
        cell.setUpData(post: posts[indexPath.row])
        return cell
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if isLoading {
            return nil
        } else {
            return NSAttributedString(string: "Empty")
        }
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if isLoading {
            return nil
        } else {
            return NSAttributedString(string: "No contents is available.")
        }
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        if isLoading {
            return nil
        } else {
            return NSAttributedString(string: "再読み込み")
        }
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        self.loadTimeline()
    }
}
