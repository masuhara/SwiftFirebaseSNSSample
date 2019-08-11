//
//  UserHeaderTableViewCell.swift
//  FirebaseSNSSample
//
//  Created by Masuhara on 2019/07/08.
//  Copyright © 2019 Ylab Inc. All rights reserved.
//

import UIKit

class UserHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func favoriteList() {
        
    }
    
}
