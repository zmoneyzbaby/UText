//
//  LoginViewController.swift
//  team16
//
//  Created by Zephyr Reames-Zepeda on 11/1/21.

import UIKit
import Firebase
import CometChatPro
import FirebaseStorage

class LoginViewController: UIViewController {
    private let storage = Storage.storage().reference()
    // segmented control
    @IBOutlet weak var loginOrSignUp: UISegmentedControl!
    
    var results : [String : Any]?
    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var userIdLabel: UILabel!
    // status label and button(Login) text label
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var buttonText: UIButton!
    
    // password labels and textfield
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    
    // confirm your passwords
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var confirmLabel: UILabel!
    var userChoice = ""
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var lastNameText: UITextField!
    
    @IBOutlet weak var currImage: UIImageView!
    
    @IBOutlet weak var topImage: UIImageView!
    
    
    
    
    
    
    
    
    var tempEmail : String! = ""
    var tempFirst : String! = ""
    var tempLast : String! = ""
    var tempUrl : String! = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        loginOrSignUp.backgroundColor = UIColor.orange
        loginOrSignUp.layer.borderColor = UIColor.white.cgColor
        loginOrSignUp.selectedSegmentTintColor = UIColor.white
        loginOrSignUp.layer.borderWidth = 1
        loginOrSignUp.selectedSegmentIndex = 0
        selectLogin()
        
        // Change the background image
        
        UIView.animate(withDuration: 1.0, delay: 0.2, options:[ .autoreverse,.repeat], animations : {
            self.currImage.frame.origin.x += 10
        })
        
        // Animate the cute babe two.
        UIView.animate(withDuration: 1.0, delay: 0.2, options:[ .autoreverse,.repeat], animations : {
            self.topImage.frame.origin.x -= 10
        })
        Auth.auth().addStateDidChangeListener() {
          auth, user in

          if user != nil {
            self.performSegue(withIdentifier: "welcome", sender: nil)
            self.userIDTextField.text = nil
            self.passwordTextField.text = nil
          }
        }
        
        do { try Auth.auth().signOut() }
                catch{print("error")}
    }
        // Do any additional setup after loading the view
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
           return false
    }
    
    @IBAction func segChanged(_ sender: Any) {
        selectLogin()
    }
    
    func selectLogin() {
        switch loginOrSignUp.selectedSegmentIndex {
            
        // First
        case 0:
            userChoice = "Login"
            buttonText.titleLabel!.text = "Sign In"
            buttonText.setTitle("Sign In", for: .normal)
            confirmLabel.isHidden = true
            confirmTextField.isHidden = true
            userIdLabel.isHidden = false
            userIDTextField.isHidden = false
            passwordTextField.isHidden = false
            passwordLabel.isHidden = false
            statusLabel.isHidden = false
            buttonText.isHidden = false
            firstName.isHidden = true
            firstNameText.isHidden = true
            lastNameText.isHidden = true
            lastNameLabel.isHidden = true


            
        // Second
        case 1:
            userChoice = "Signup"
            buttonText.titleLabel!.text = "Sign Up"
            buttonText.setTitle("Sign Up", for: .normal)
            confirmLabel.isHidden = false
            confirmTextField.isHidden = false
            userIdLabel.isHidden = false
            userIDTextField.isHidden = false
            passwordTextField.isHidden = false
            passwordLabel.isHidden = false
            statusLabel.isHidden = false
            buttonText.isHidden = false
            firstName.isHidden = false
            firstNameText.isHidden = false
            lastNameText.isHidden = false
            lastNameLabel.isHidden = false
 
            
        default:
            userChoice = "error"
        }
    }
    
    func createAuth(){
        print("CAME TO AUTH")
        Auth.auth().createUser(withEmail: userIDTextField.text!, password: passwordTextField.text!, completion: { AuthDataResult, Error in
                let email = AuthDataResult?.user.email
    
        })
    }
 
           
    @IBAction func buttonPressed(_ sender: Any) {
        let db = Firestore.firestore()
        tempEmail = userIDTextField.text as! String
        tempFirst = firstNameText.text as! String
        tempLast = lastNameText.text as! String
    
 
       
        tempEmail = tempEmail.lowercased()
    
        
        
        if (buttonText.titleLabel?.text == "Sign In") {
            
            guard let email = tempEmail,
                  let password = passwordTextField.text,
                  email.contains("utexas"),
                  password.count > 0
            else {
                return
            }
            
            
            Auth.auth().signIn(withEmail: tempEmail, password: password) {
              user, error in
                if user == nil {
                self.statusLabel.text = "Sign in failed"
                }
                else {
         
                    print(self.tempEmail!)
                    print("dooc to write \(self.tempEmail!)")
                    let docRef = db.collection("users").document("\(self.tempEmail!)")
                        
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            print(document)
                            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
    
                            self.results = document.data()!
                            
                            DispatchQueue.main.async {
                                userEmail = self.tempEmail!
                                userComet = self.results!["cometId"] as! String
                                userFirst = self.results!["firstname"] as! String
                                userLast = self.results!["lastname"] as! String
                                userURL = self.results!["picurl"] as? String
                                
                                print(userFirst)
                                print(userLast)
                               
                                print("success")
                                print(userEmail)
                            }
                        } else {
                            print("Document does not exist")
                        }
                    }
                   userEmail = email
                }
            }
        }
       
        else if (buttonText.titleLabel?.text == "Sign Up") {
            let firstName : String = firstNameText.text!
            let lastName : String = lastNameText.text!
            if (checkInfo()){
                return
            }
            else {
                
                createAuth()
                
               
                
                //get default Image // Fetch the download URL
                let defaulImageRef = self.storage.child("images/user.png")
                defaulImageRef.downloadURL { url, error in
                    if let error = error {
                            print("erorr")
                    } else {
                        userURL = url?.absoluteString
                    }
                 }
                
                let fix : String  = userIDTextField.text as! String
                userEmail = fix.lowercased()
                
                
                var rawCometId = userEmail
                rawCometId = rawCometId!.replacingOccurrences(of: "@", with: "-")
                rawCometId = rawCometId!.replacingOccurrences(of: " ", with: "")
                rawCometId = rawCometId!.replacingOccurrences(of: ".", with: "-")
                
                userComet = rawCometId?.lowercased()
            
                
                        // creat doc in firstore
                db.collection("users").document(userEmail!).setData([
                        "firstname": "\(firstName)",
                        "lastname": "\(lastName)",
                        "cometId" : "\(userComet!)",
                        "picurl": ""
                            
                        ]) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                print("Document successfully written!")
                            }
                        }
                        
                    let newUser = User(uid: "\(userComet!)", name: "\(firstName)") // Replace with your uid and the name for the user to be created.
                    newUser.avatar = userURL
                   
                    let authKey = "50264e3ed1337364db7f5211bb956e9387b2d7d0" // Replace with your Auth Key.
                    CometChat.createUser(user: newUser, apiKey: authKey, onSuccess: { (User) in
                          print("User created successfully. \(User.stringValue())")
                    }) { (error) in
                         print("The error is \(String(describing: error?.description))")
                    }
                    let profileImage = UIImage(named:"user")!
                    let imageData = profileImage.pngData()
                    self.storage.child("images/\(userComet!).png").putData(imageData!,
                                                            metadata: nil,
                                                            completion: { _, error  in
                                                            guard error == nil else{
                                                           
                                                                self.showAlert(title: "failed", msg: "Unable to Save Updates")
                                                                return
                                                            }
                                                      
                                                            })
        
                
                
                    
                    
                    Auth.auth().signIn(withEmail: self.userIDTextField.text!,
                                    password: self.passwordTextField.text!)
            
            }
                
        }
    }
    
    
    func checkInfo() -> Bool{
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}"
        let isMatched = NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: self.passwordTextField.text)
        
        if (!userIDTextField.text!.contains("utexas")) {
                let controller = UIAlertController(
                    title: "UT-Affiliated Email Address Needed",
                    message: "please use your UT email address",
                    preferredStyle: .alert)
                    controller.addAction(UIAlertAction(
                                            title: "OK",
                                            style: .default,
                                            handler: nil))
                    self.present(controller, animated: true, completion: nil)
                userIDTextField.text = ""
                passwordTextField.text = ""
                confirmTextField.text = ""
                firstNameText.text = ""
                lastNameText.text = ""
            
                return true
            }
            else if (passwordTextField.text!.count < 8) {
                    let controller = UIAlertController(
                        title: "Less than 8 characters of password input",
                        message: "please make your password at minimum of 8 characters",
                        preferredStyle: .alert)
                    controller.addAction(UIAlertAction(
                                            title: "OK",
                                            style: .default,
                                            handler: nil))
                    self.present(controller, animated: true, completion: nil)
                    return true
            } else if (!isMatched) {
                    let controller = UIAlertController(
                        title: "wrong password input",
                        message: "please include an uppercase letter, a lowercase letter, a number, and a special character in your password",
                        preferredStyle: .alert)
                    controller.addAction(UIAlertAction(
                                            title: "OK",
                                            style: .default,
                                            handler: nil))
                    self.present(controller, animated: true, completion: nil)
                    return true
            } else if (passwordTextField.text! != confirmTextField.text!) {
                let controller = UIAlertController(
                    title: "passwords don't match",
                    message: "please make sure your passwords are matching",
                    preferredStyle: .alert)
                controller.addAction(UIAlertAction(
                                        title: "OK",
                                        style: .default,
                                        handler: nil))
                self.present(controller, animated: true, completion: nil)
                    return true
            }
        return false
    }
    
   
}
