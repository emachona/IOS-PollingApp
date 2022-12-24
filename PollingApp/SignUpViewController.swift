//
//  SignUpViewController.swift
//  PollingApp
//
//  Created by Emilija Chona on 12/14/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {

    var typeOfUser = " "
    private let database = Database.database().reference()
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    
    @IBOutlet weak var avSwitch: UISwitch!
    @IBOutlet weak var voterLabel: UILabel!
    @IBOutlet weak var adminLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signupPressed(_ sender: Any) {
        if emailTF.text?.isEmpty == true {
            print("Email field can't be empty!")
            //displayAlert(title: "Missing Information", message: "You must provide email!")
            return
        }
        
        if passwordTF.text?.isEmpty == true {
            print("Password field can't be empty!")
            //displayAlert(title: "Missing Information", message: "You must provide password!")
            return
        }
        
        signUp()
    }
    
    func signUp(){
        Auth.auth().createUser(withEmail: emailTF.text!, password: passwordTF.text!){
            (user, error) in  if error != nil{
                print("Error \(error?.localizedDescription)")
                //self.displayAlert(title: "Error", message: error!.localizedDescription)
                return
            }
            else{
                print("Sign Up Success!")
                if self.avSwitch.isOn{
                    self.typeOfUser = "Administrator"
                }else{
                    self.typeOfUser = "Voter"
                }
                let object : [String:Any] = [
                    "name" : self.nameTF.text as Any,
                    "age" : self.ageTF.text as Any,
                    "phone" : self.phoneTF.text as Any,
                    "address" : self.addressTF.text as Any,
                    "username" : self.emailTF.text as Any,
                    "password" : self.passwordTF.text as Any,
                    "type" : self.typeOfUser,
                    "noOfVotings" : 0
                ]
                let userID : String = (Auth.auth().currentUser?.uid)!
                print("Current user ID is" + userID)
                self.database.child("users").child(userID).setValue(object)
                print("Object written!")
                
                if self.typeOfUser == "Administrator" {
                    //Administrator
                    let req = Auth.auth().currentUser?.createProfileChangeRequest();
                    req?.displayName = "Administrator"
                    req?.commitChanges(completion: nil)
                    self.performSegue(withIdentifier: "adminSegue1", sender: nil)
                }
                else {
                    //Voter
                    let req = Auth.auth().currentUser?.createProfileChangeRequest();
                    req?.displayName = "Voter"
                    req?.commitChanges(completion: nil)
                    self.performSegue(withIdentifier: "voterSegue1", sender: nil)
                }
            }
        }
    }
}
