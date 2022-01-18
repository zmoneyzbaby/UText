//
//  ProfileViewController.swift
//  team16
//
//  Created by Zephyr Reames-Zepeda on 11/1/21.


import UIKit
import FirebaseCore
import FirebaseStorage
import CometChatPro

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let storage = Storage.storage().reference()
    var urlString : String!
    var newImage: UIImage!
    var edited = false;
    var imageInfo : Data?
    let defaults = UserDefaults.standard
    var url : URL!
    var photoEdited = false
    
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var SaveButtonPressed: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = background[defaults.integer(forKey: "theme")]
        self.loading.isHidden = true
        if (!edited){
        
        self.storage.child("images/\(userComet).png").downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                    //self.profilePicture.image = UIImage(named: "user")
                    print("failed")
                    return
                }
                
                self.url = url
            let task = URLSession.shared.dataTask(with: self.url!, completionHandler: { data, _, error in
                guard let data = data, error == nil else {
                    
                    return
                }
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self.profilePicture.image = image
             
                    print("sucess")
                }
            
                })
                task.resume()
                })
        }
            
       
       
            
           
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.layer.masksToBounds
        profilePicture.layer.cornerRadius = profilePicture.bounds.width/2
        
        
    }
    
    @IBAction func updatePhotoPressed(_ sender: Any) {
        
        let actions = UIAlertController(title: "Update Profile Picture",
                                        message: "Choose source for Photo",
                                        preferredStyle: .actionSheet)
        
        actions.addAction(UIAlertAction(title: "Cancel",
                                        style: .cancel,
                                        handler: nil))
        
        actions.addAction(UIAlertAction(title: "Chose Photo",
                                        style: .default,
                                        handler: { [weak self] _ in
                let photoSelecter = UIImagePickerController()
                photoSelecter.sourceType = .photoLibrary
                photoSelecter.delegate = self
                photoSelecter.allowsEditing = true
                self?.present(photoSelecter, animated: true)
        }))
        
        
        actions.addAction(UIAlertAction(title: "Take Picture",
                                        style: .default,
                                        handler: { [weak self]_ in
            let photoSelecter2 = UIImagePickerController()
            photoSelecter2.sourceType = .camera
            photoSelecter2.delegate = self
            photoSelecter2.allowsEditing = true
            self?.present(photoSelecter2, animated: true)
        }))
        present(actions, animated: true)
       
    }
    
    func imagePickerController(_ photoSelecter: UIImagePickerController, didFinishPickingMediaWithInfo info:
        [UIImagePickerController.InfoKey : Any]){
        photoSelecter.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        
        edited = true
        newImage = image
        imageInfo = imageData
        self.profilePicture.image = self.newImage
      
    }
    func imagePickerControllerDidCancel(_ photoSelecter : UIImagePickerController){
        photoSelecter.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    func updateCometChatAvatar() {
        var updateFirst = ""
        var updateLast  = ""
        
        if firstNameText.text == "" {
            updateFirst = userFirst!
        }else {
            updateFirst = firstNameText.text!
        }
        if lastNameText.text == "" {
            updateLast = userLast!
        } else {
            updateLast = lastNameText.text!
        }
        
        let user = User(uid: "\(userComet)", name: "\(updateFirst) \(updateLast)")
        if photoEdited {
            photoEdited = false
            user.avatar = "\(userURL!)"
        }
            CometChat.updateCurrentUserDetails(user: user, onSuccess:{ user in
                print("Updated user object",user)
                DispatchQueue.main.async{
                    userFirst  = self.firstNameText.text
                    userLast = self.lastNameText.text
                    self.loading.isHidden = true
                    self.loading.stopAnimating()
                }
                
            }, onError: { error in
                print("Update user failed with error: \(error?.errorDescription)")
            })
    }
    
    
   // @IBACtion func saveButtonPressed(_sender: Any){
        
        
   // }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if firstNameText.text != "" || lastNameText.text != "" {
            edited = true
        }
        if edited{
            edited = false
            
            let queue1 = DispatchQueue(label: "updating",
            qos: .userInitiated)
            
            
            if(photoEdited) {
            queue1.async {
                DispatchQueue.main.async {
                    self.loading.isHidden = false
                    self.loading.startAnimating()
                }
                self.storage.child("images/\(userComet).png").putData(self.imageInfo!,
                                                            metadata: nil,
                                                            completion: { _, error  in
                                                            guard error == nil else{
                                                           
                                                                self.showAlert(title: "failed", msg: "Unable to Save Updates")
                                                                return
                                                            }
                                                                self.storage.child("images/\(userComet).png").downloadURL(completion: { url, error in
                                                                    guard let url  = url, error == nil else {
                                                                            return
                                                                    }
                                                                    userURL = url.absoluteString
                                                                self.urlString = url.absoluteString
                                                                DispatchQueue.main.async {
                                                                    self.profilePicture.image = self.newImage
                                                                }
                                                                
                                                                
                                                            })
            })
        }
                
            }
            
            self.showAlert(title: "saved", msg: "Profile Updated")
            self.updateCometChatAvatar()
        }
    }
}
