//
//  MyVotingsViewController.swift
//  PollingApp
//
//  Created by Emilija Chona on 12/26/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MyVotingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableview: UITableView!
    private let ref = Database.database().reference()
    let currUserID : String = (Auth.auth().currentUser?.uid)!
    var zaPrikaz = [String]()
    var glasanja = voteModel()
    var chosenAns = ""
    
    override func viewDidLoad() {
        getResultsData()
        super.viewDidLoad()
        
        self.tableview.dataSource = self
        self.tableview.delegate = self
    }
    
    func getResultsData() {
        ref.child("results").observeSingleEvent(of: .value, with: { (snapshot) in
            
            print("There are \(snapshot.childrenCount) results found where you voted")
            
            if snapshot.childrenCount > 0 {
                print("childrenCount > 0")
                
                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    if let data = data.value as? [String: Any] {
                        print(data)
                        if data["voter"] as! String == self.currUserID {//gi pominuva polls i gleda kade currUser e voter
                            let anketaId = data["questionID"]//gi zema site polls kade currUser e voter
                            self.chosenAns = data["answer"] as! String
                            self.zaPrikaz.append(anketaId! as! String)//gi stava polls za prikaz vo niza
                            print(self.zaPrikaz)
                            self.getPolls()
//                            self.tableview.reloadData()
                        }
                    }
                }
            }
        })
    }
    
    func getPolls() {
        for pollId in zaPrikaz{ //gi pominuva site pollIds za prikaz
            print("vleguva za " + pollId)
            ref.child("polls").child(pollId).observeSingleEvent(of: .value, with: { (snapshot) in //za sekoe pollId zema podatoci

                if snapshot.exists() { //snapshot e poll so dadenoto id, odnosno data

                    if let data = snapshot.value as? [String: String] {//if let data = data.value as? [String: String]
                        print(data as Any)
                        let glasanje = glas(prashanje: data["question"]!, odgovor: self.chosenAns, pocetok: data["startDate"]!, kraj: data["endDate"]!)
                        self.glasanja.site.append(glasanje)
                        print(self.glasanja.site)
                        self.tableview.reloadData()
                    }
                }
            })
        }
    }
    
    
    //MARK: Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return glasanja.site.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "voteCell", for: indexPath) as! VoteTableViewCell
        
        cell.questionTL?.text = self.glasanja.site[indexPath.row].prashanje
        cell.answerTL?.text = "Your answer is: " + self.glasanja.site[indexPath.row].odgovor
        cell.startTL?.text = "start: " + self.glasanja.site[indexPath.row].pocetok
        cell.endTL?.text = "end: " + self.glasanja.site[indexPath.row].kraj
        
        return cell
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
