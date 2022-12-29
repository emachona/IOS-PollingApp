//
//  DetailsViewController.swift
//  PollingApp
//
//  Created by Emilija Chona on 12/21/22.
//

import UIKit
import FirebaseDatabase

class DetailsViewController: UIViewController {

    private let ref = Database.database().reference()
    public var question = ""
    public var startDate = ""
    public var endDate = ""
    var newStart = ""
    var newEnd = ""
    var pollID = ""
    let formatter = DateFormatter()
    @IBOutlet weak var questionTL: UILabel!
    @IBOutlet weak var endTL: UILabel!
    @IBOutlet weak var startTL: UILabel!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        findPoll()
        super.viewDidLoad()
        
        questionTL.text = question
        startTL.text = "Start time is: " + startDate
        endTL.text = "End time is: " + endDate

        // Do any additional setup after loading the view.
    }
    
    func findPoll(){
        ref.child("polls").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    if let poll = data.value as? [String: String] {
                        if poll["question"] == self.question {
                            self.pollID = data.key
                            }
                        }
                    }
                }
            })
    }
    
    @IBAction func makeChanges(_ sender: Any) {
        if newStart == "" && newEnd == "" {
           print("No changes set to make")
        }else{
            if newStart != "" {
                self.ref.child("polls/\(self.pollID)/startDate").setValue(self.newStart)
            }
            if newEnd != "" {
                self.ref.child("polls/\(self.pollID)/endDate").setValue(self.newEnd)
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier:"adminView")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }
    }

    @IBAction func startTimePicked(_ sender: Any) {
        formatter.dateFormat = "E, dd MMM yyyy HH:mm"
        var startStr = formatter.string(from: startDatePicker.date)
        self.newStart = startStr
    }
    
    @IBAction func endTimePicked(_ sender: Any) {
        formatter.dateFormat = "E, dd MMM yyyy HH:mm"
        var endStr = formatter.string(from: endDatePicker.date)
        self.newEnd = endStr
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
