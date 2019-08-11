//
//  SignUpViewController.swift
//  FirebaseSNSSample
//
//  Created by Masuhara on 2019/07/06.
//  Copyright © 2019 Ylab Inc. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftMessages

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
    }
    
    func configureTextFields() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func signUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        SVProgressHUD.show()
        UserModel.signUp(email: email, password: password) { (error) in
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
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
