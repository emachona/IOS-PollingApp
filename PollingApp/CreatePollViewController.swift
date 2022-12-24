//
//  CreatePollViewController.swift
//  PollingApp
//
//  Created by Emilija Chona on 12/19/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreatePollViewController: UIViewController {

    private let ref = Database.database().reference()
    var userName = "Admin"
    var start : String?
    var end : String?
    let formatter = DateFormatter()
    let now = Date()
    var status = "false"
    
    @IBOutlet weak var adminTF: UILabel!
    @IBOutlet weak var questionTF: UITextField!

    @IBOutlet weak var ans1TF: UITextField!
    @IBOutlet weak var ans2TF: UITextField!
    @IBOutlet weak var ans3TF: UITextField!
    @IBOutlet weak var ans4TF: UITextField!
    @IBOutlet weak var ans5TF: UITextField!
    @IBOutlet weak var ans6TF: UITextField!
    @IBOutlet weak var ans7TF: UITextField!
    @IBOutlet weak var ans8TF: UITextField!
    
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var endTime: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currUserID : String = (Auth.auth().currentUser?.uid)!
        ref.child("users/\(currUserID)/name").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.userName = snapshot?.value as! String;
            print(self.userName)
            self.adminTF.text = snapshot?.value as! String + " asks:"
        });
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        if start?.isEmpty != nil && end?.isEmpty != nil {
            status = "true"// ako start e pred deneshniot datum
        }
        //proverka dali se popolneti site zadolzitelni polinja
        //ako ne se --abort
        create()
    }
    
    func create(){
        let userID : String = (Auth.auth().currentUser?.uid)!
        print("Current user ID is" + userID)
        
        let object : [String:String?] = [
            "question" : questionTF.text!,
            "ans1" : ans1TF.text!,
            "ans2" : ans2TF.text!,
            "ans3" : ans3TF.text!,
            "ans4" : ans4TF.text!,
            "ans5" : ans5TF.text!,
            "ans6" : ans6TF.text,
            "ans7" : ans7TF.text,
            "ans8" : ans8TF.text,
            "adminName" : userName,
            "adminId" : userID,
            "startDate" : start,
            "endDate" : end,
            "active" : status
        ]
        
        self.ref.child("polls").childByAutoId().setValue(object)
        print("Object written!")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier:"adminView")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    
    @IBAction func startDatePicked(_ sender: UIDatePicker) {
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        //formatter.timeStyle = DateFormatter.Style.medium

        var startStr = formatter.string(from: startTime.date)
        self.start = startStr
        
    }
    
    @IBAction func endDatePicked(_ sender: Any) {
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        //formatter.timeStyle = DateFormatter.Style.medium

        var endStr = formatter.string(from: endTime.date)
        self.end = endStr
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
