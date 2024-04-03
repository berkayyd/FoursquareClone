//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Berkay Demir on 31.03.2024.
//

import UIKit
import Parse

class SignUpVC: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let parseObject = PFObject(className: "fruits")
        parseObject["name"] = "banana"
        parseObject["calories"] = 150
        parseObject.saveInBackground { success , error in
            if error != nil {
                print(error?.localizedDescription)
            }else {
                print("uploaded")
            }
        }
         */
        
        /*
        let query = PFQuery(className: "fruits")
        query.findObjectsInBackground { objects, error in
            if error != nil {
                print(error?.localizedDescription)
            }else{
                print(objects)
            }
        }
         */
        
        
    }
    
    
    @IBAction func signInClicked(_ sender: Any) {
        if usernameText.text != "" && passwordText.text != "" {
            PFUser.logInWithUsername(inBackground: usernameText.text!, password: passwordText.text!) { user, error in
                if error != nil {
                    self.makeAlert(titleInput: "ERROR!", messageInput: error?.localizedDescription ?? "Error!!!")
                }else {
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        }else {
            makeAlert(titleInput: "ERROR!", messageInput: "Username / Password ??")
        }
    }
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        if usernameText.text != "" && passwordText.text != "" {
            let user = PFUser()
            user.username = usernameText.text
            user.password = passwordText.text
            user.signUpInBackground { succes , error in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                }else {
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        }else {
            makeAlert(titleInput: "ERROR!", messageInput: "Username / Password ??")
        }
    }
    
    func makeAlert(titleInput:String , messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}

