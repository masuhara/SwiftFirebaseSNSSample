//
//  PostViewController.swift
//  FirebaseSNSSample
//
//  Created by Masuhara on 2019/07/07.
//  Copyright © 2019 Ylab Inc. All rights reserved.
//

import UIKit
import SwiftMessages
import SVProgressHUD
import FontAwesome_swift

class PostViewController: UIViewController {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var selectImageButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        postTextView.delegate = self
        selectImageButton.setImage(UIImage.fontAwesomeIcon(name: .camera, style: .solid, textColor: .lightGray, size: selectImageButton.bounds.size), for: .normal)
    }
    
    @IBAction func savePost() {
        // Close Keyboard
        if postTextView.isFirstResponder == true {
            postTextView.resignFirstResponder()
        }
        
        // Get Image Data
        guard let data = postImageView.image?.pngData() else { return }
        
        // Save Image
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
        
        ImageUploader.save(imageData: data) { (url, error) in
            if let error = error {
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.showError(error: error)
                }
            } else {
                if let url = url {
                    var post = Post()
                    post.photoURL = url.absoluteString
                    post.text = self.postTextView.text
                    post.save(completion: { (error) in
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            if let error = error {
                                self.showError(error: error)
                            } else {
                                self.showSucsessAlert()
                            }
                        }
                    })
                } else {
                    // no url available
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self.showError()
                    }
                }
            }
            
        }
    }
    
    @IBAction func selectImage() {
        let alertController = UIAlertController(title: "写真を選択", message: "投稿する写真を選択して下さい", preferredStyle: .actionSheet)
        // for iPad
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = selectImageButton.frame
        
        let cameraAction = UIAlertAction(title: "カメラで撮影", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
            // camera
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        let photolibraryAction = UIAlertAction(title: "フォトライブラリから選択", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
            // photolibrary
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cameraAction)
        alertController.addAction(photolibraryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showSucsessAlert() {
        let alert = UIAlertController(title: "投稿完了", message: "投稿が完了しました。タイムラインに戻ります。", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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

extension PostViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage]
            as? UIImage {
            self.postImageView.image = pickedImage
            self.selectImageButton.isHidden = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
