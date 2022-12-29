//
//  VotingViewController.swift
//  PollingApp
//
//  Created by Emilija Chona on 12/24/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class VotingViewController: UIViewController, CLLocationManagerDelegate{

    var manager = CLLocationManager()
    public var quest = ""
    var odgovori = [String]()
    var selectedAns = ""
    var pollID = ""
    var ansNum = 0
    var lat = ""
    var lon = ""
    private let ref = Database.database().reference()
    @IBOutlet weak var questionTF: UILabel!
    @IBOutlet weak var ansPicker: UIPickerView!
    @IBOutlet weak var chosenAnswerTL: UILabel!
    
    override func viewDidLoad() {
        getData()
        super.viewDidLoad()
        questionTF.text = quest

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        ansPicker.dataSource = self
        ansPicker.delegate = self
    }
    
    func getData() {
        ref.child("polls").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                
                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    if let poll = data.value as? [String: String] {
                        if poll["question"] == self.quest {
                            self.pollID = data.key
                            print(self.pollID + " - vo for")
                            self.odgovori.append(poll["ans1"]!)
                            self.odgovori.append(poll["ans2"]!)
                            self.odgovori.append(poll["ans3"]!)
                            self.odgovori.append(poll["ans4"]!)
                            self.odgovori.append(poll["ans5"]!)
                            if poll["ans6"] != ""{
                                self.odgovori.append(poll["ans6"]!)
                            }
                            if poll["ans7"] != ""{
                                self.odgovori.append(poll["ans7"]!)
                            }
                            if poll["ans8"] != ""{
                                self.odgovori.append(poll["ans8"]!)
                            }
                            print(self.odgovori)
                            self.ansPicker.reloadAllComponents()
                            break
                        }
                    }
                }
            }
        })
    }

    @IBAction func SubmitVote(_ sender: Any) {
        publishResult()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier:"voterView")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.lat = "\(locValue.latitude)"
        self.lon = "\(locValue.longitude)"
//        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
//        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        let region = MKCoordinateRegion(center: location, span: span)
//        self.map.setRegion(region, animated: true)
    }
    
    func publishResult(){
        let currUserID : String = (Auth.auth().currentUser?.uid)!
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        let time = formatter.string(from: currentDate)
        
        let object : [String:Any?] = [
            "question" : quest,
            "questionID" : pollID,
            "answer" : selectedAns,
            "answerNumber" : ansNum+1,
            "voter" : currUserID,
            "time" : time,
            "latitude" : self.lat,
            "longitude" : self.lon
        ]
        
        self.ref.child("results").childByAutoId().setValue(object)
        print("Result published!")
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

extension VotingViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return odgovori.count
    }
}
    
extension VotingViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return odgovori[row]
    }
    
// Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedAns = odgovori[row]// selected item
        ansNum = row
        chosenAnswerTL.text = "Your chosen answer is: " + selectedAns
    }
}
