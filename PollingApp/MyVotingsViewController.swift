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
    var zaPrikaz:Array<Rezultat> = Array()
//    var zaPrikaz = [String]()
    var glasanja = voteModel()
    var chosenAns = ""
    let currentDateTime = Date()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        getResultsData()
        super.viewDidLoad()
        
        formatter.dateFormat = "E, dd MMM yyyy HH:mm"
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
                            let aPoll = Rezultat(Prashanje: anketaId as! String, Odgovor: self.chosenAns)
                            self.zaPrikaz.append(aPoll)//gi stava polls za prikaz vo niza
                            print(self.zaPrikaz)
//                            self.tableview.reloadData()
                        }
                    }
                }
                self.getPolls()
            }
        })
    }
    
    func getPolls() {
        for pollId in zaPrikaz{ //gi pominuva site pollIds za prikaz
            print("vleguva za " + pollId.prashanje)
            ref.child("polls").child(pollId.prashanje).observeSingleEvent(of: .value, with: { (snapshot) in //za sekoe pollId zema podatoci

                if snapshot.exists() { //snapshot e poll so dadenoto id, odnosno data

                    if let data = snapshot.value as? [String: String] {//if let data = data.value as? [String: String]
                        print(data as Any)
                        let glasanje = glas(prashanje: data["question"]!, odgovor: pollId.odgovor, pocetok: data["startDate"]!, kraj: data["endDate"]!)
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
        formatter.dateFormat = "E, dd MMM yyyy HH:mm"
        let start = formatter.date(from:self.glasanja.site[indexPath.row].pocetok)!
        let end = formatter.date(from:self.glasanja.site[indexPath.row].kraj)!
        if end < currentDateTime {
            //finished
            cell.contentView.backgroundColor = #colorLiteral(red: 0.6007743047, green: 0.6246629124, blue: 0.6154355441, alpha: 1)
            glasanja.site[indexPath.row].status = 2
        }else if currentDateTime < start{
            //not started
            cell.contentView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            glasanja.site[indexPath.row].status = 0
        }else if start < currentDateTime {
            //active
            cell.contentView.backgroundColor = #colorLiteral(red: 0.686188817, green: 1, blue: 0.737815595, alpha: 1)
            glasanja.site[indexPath.row].status = 1
        }else {
            cell.contentView.backgroundColor = UIColor.white
        }
        cell.questionTL?.text = self.glasanja.site[indexPath.row].prashanje
        cell.answerTL?.text = "Your answer is: " + self.glasanja.site[indexPath.row].odgovor
        cell.startTL?.text = "start: " + self.glasanja.site[indexPath.row].pocetok
        cell.endTL?.text = "end: " + self.glasanja.site[indexPath.row].kraj
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if glasanja.site[indexPath.row].status == 2{
            //ako e zavrsheno vidi rezultati
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier:"voterResults")as? DetailsViewController //VoterResultsViewController !!!
            vc?.question = glasanja.site[indexPath.row].prashanje
            vc?.startDate = glasanja.site[indexPath.row].pocetok
            vc?.endDate = glasanja.site[indexPath.row].kraj
            vc!.modalPresentationStyle = .overFullScreen
            present(vc!, animated: true)
        }
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
