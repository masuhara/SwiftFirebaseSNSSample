//
//  PostTableViewCell.swift
//  FirebaseSNSSample
//
//  Created by Masuhara on 2019/07/07.
//  Copyright © 2019 Ylab Inc. All rights reserved.
//

import UIKit
import FontAwesome_swift

protocol PostTableViewCellDelegate {
    func didTapFavoriteButton(button: UIButton, cell: UITableViewCell)
    func didTapCommentButton(button: UIButton, cell: UITableViewCell)
}

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var delegate: PostTableViewCellDelegate?
    
    @IBOutlet weak var favoriteButton: UIButton! {
        didSet {
            favoriteButton.tintColor = UIColor.lightGray
            favoriteButton.setImage(UIImage.fontAwesomeIcon(name: .heart, style: .regular, textColor: .lightGray, size: favoriteButton.bounds.size), for: .normal)
        }
    }
    
    @IBOutlet weak var commentButton: UIButton! {
        didSet {
            commentButton.tintColor = UIColor.lightGray
            commentButton.setImage(UIImage.fontAwesomeIcon(name: .comment, style: .regular, textColor: .lightGray, size: commentButton.bounds.size), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpData(post: Post) {
        self.photoImageView.kf.setImage(with: URL(string: post.photoURL))
        self.userNameLabel.text = post.userId
        let timeInterval = TimeInterval(post.createdAt)!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ja_JP")
        let timeString = formatter.string(for: Date(timeIntervalSince1970: timeInterval))
        self.timeLabel.text = timeString
        self.descriptionTextView.text = post.text
        self.favoriteCountLabel.text = String(post.favoriteUsers?.count ?? 0)
        
        guard let userId = UserModel.currentUser()?.uid else { return }
        if post.favoriteUsers?.contains(userId) == true {
            favoriteButton.tintColor = UIColor.red
            favoriteButton.setImage(UIImage.fontAwesomeIcon(name: .heart, style: .solid, textColor: .red, size: favoriteButton.bounds.size), for: .normal)
        } else {
            favoriteButton.tintColor = UIColor.lightGray
            favoriteButton.setImage(UIImage.fontAwesomeIcon(name: .heart, style: .regular, textColor: .lightGray, size: favoriteButton.bounds.size), for: .normal)
        }
    }
    
    @IBAction func fovorite(button: UIButton) {
        self.delegate?.didTapFavoriteButton(button: button, cell: self)
    }
    
    @IBAction func comment(button: UIButton) {
        self.delegate?.didTapCommentButton(button: button, cell: self)
    }
    
}
