//
//  LoginViewController.swift
//  FirebaseSNSSample
//
//  Created by Masuhara on 2019/07/06.
//  Copyright © 2019 Ylab Inc. All rights reserved.
//

import UIKit
import Pastel
import ActiveLabel
import SwiftMessages
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpLabel: ActiveLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientView()
        
        let customType = ActiveType.custom(pattern: "新規登録")
        signUpLabel.enabledTypes.append(customType)
        signUpLabel.text = "登録済みでない方は新規登録"
        signUpLabel.customColor[customType] = UIColor.white
        signUpLabel.handleCustomTap(for: customType) { (string) in
            self.performSegue(withIdentifier: "toSignUp", sender: nil)
        }
    }
    
    @IBAction func login() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        SVProgressHUD.show()
        UserModel.login(email: email, password: password) { (error) in
            SVProgressHUD.dismiss()
            if let error = error {
                let view = MessageView.viewFromNib(layout: .messageView)
                view.configureTheme(.error)
                view.button?.isHidden = true
                view.titleLabel?.text = "Error"
                view.bodyLabel?.text = error.localizedDescription
                SwiftMessages.show(view: view)
            } else {
                SegueManager.show(displayType: .main)
            }
        }
    }
    
    func setGradientView() {
        let pastelView = PastelView(frame: view.bounds)
        
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 3.0
        
        // Custom Color
        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                              UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                              UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }

}
