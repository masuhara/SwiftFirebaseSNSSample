//
//  UserPageViewController.swift
//  FirebaseSNSSample
//
//  Created by Masuhara on 2019/07/07.
//  Copyright © 2019 Ylab Inc. All rights reserved.
//

import UIKit
import FontAwesome_swift
import SVProgressHUD
import SwiftMessages

class UserPageViewController: UIViewController {
    
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var userPageTableView: UITableView!
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureRightBarButtonItem()
        configureTableView()
    }

    func configureRightBarButtonItem() {
        rightBarButtonItem.image = UIImage.fontAwesomeIcon(name: .cog, style: .regular, textColor: .blue, size: CGSize(width: 24.0, height: 24.0))
    }
    
    func configureTableView() {
        userPageTableView.dataSource = self
        userPageTableView.delegate = self
        userPageTableView.tableFooterView = UIView()
        userPageTableView.rowHeight = UITableView.automaticDimension
        userPageTableView.estimatedRowHeight = 44.0
        
        let userHeaderNib = UINib(nibName: "UserHeaderTableViewCell", bundle: Bundle.main)
        let postNib = UINib(nibName: "PostTableViewCell", bundle: Bundle.main)
        userPageTableView.register(userHeaderNib, forCellReuseIdentifier: "UserHeaderTableViewCell")
        userPageTableView.register(postNib, forCellReuseIdentifier: "PostTableViewCell")
    }
    
    @IBAction func openMenu() {
        let alertController = UIAlertController(title: "メニュー", message: "メニューを選択してください", preferredStyle: .actionSheet)
        let editNameAction = UIAlertAction(title: "表示名の変更", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        let editEmailAction = UIAlertAction(title: "メールアドレスの変更", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        let editPasswordAction = UIAlertAction(title: "パスワードの変更", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        let editImageAction = UIAlertAction(title: "プロフィール画像の変更", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        let logoutAction = UIAlertAction(title: "ログアウト", style: .destructive) { (action) in
            alertController.dismiss(animated: true, completion: nil)
            self.logout()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(editNameAction)
        alertController.addAction(editEmailAction)
        alertController.addAction(editPasswordAction)
        alertController.addAction(editImageAction)
        alertController.addAction(logoutAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func logout() {
        SVProgressHUD.show()
        UserModel.logout { (error) in
            SVProgressHUD.dismiss()
            if let error = error {
                self.showError(error: error)
            } else {
                SegueManager.show(displayType: .login)
            }
        }
    }
    
    func showError(error: Error? = nil) {
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(.error)
        view.button?.isHidden = true
        view.titleLabel?.text = "Error"
        view.bodyLabel?.text = error?.localizedDescription
        SwiftMessages.show(view: view)
    }

}

extension UserPageViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            // return posts.count
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserHeaderTableViewCell") as! UserHeaderTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
            return cell
        }
    }
}
