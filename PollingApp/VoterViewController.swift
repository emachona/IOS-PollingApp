//
//  VoterViewController.swift
//  PollingApp
//
//  Created by Emilija Chona on 12/24/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class VoterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableview: UITableView!
    private let ref = Database.database().reference()
    let currUserID : String = (Auth.auth().currentUser?.uid)!
    var glasanja = model()
    var notShowing = [String]()
    var toShow = [String]()
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
            
            print("There are \(snapshot.childrenCount) results found where someone voted")
            
            if snapshot.childrenCount > 0 {
                
                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    if let data = data.value as? [String: Any] {
                        if data["voter"] as! String == self.currUserID {//gi pominuva polls i gleda kade currUser e voter
                            let anketaId = data["questionID"]//gi zema site polls kade currUser e voter
                            self.notShowing.append(anketaId! as! String)//gi stava polls kade glasal koi NE se za prikaz vo niza
                        }
                    }
                }
                print("Listata notShowing e:")
                print(self.notShowing)
                self.getData()
            }
        })
    }
    
    func getData() {
        ref.child("polls").observeSingleEvent(of: .value, with: { (snapshot) in
            
            print("There are \(snapshot.childrenCount) polls found")

            if snapshot.childrenCount > 0 {

                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    if let anketa = data.value as? [String: String] {
                        if self.notShowing.isEmpty{
                            print("Nema nisto vo notShowing")
                            if anketa["active"] == "true"{
                                let glasanje = zapis(prashanje: anketa["question"]!, pocetok: anketa["startDate"]!, kraj: anketa["endDate"]!)
                                self.glasanja.site.append(glasanje)
                                print(self.glasanja.site)
                                self.tableview.reloadData()
                            }
                        }else{
                            if(self.notShowing.contains(data.key)){
                                continue;
                            }else if anketa["active"] == "true"{
                                let glasanje = zapis(prashanje: anketa["question"]!, pocetok: anketa["startDate"]!, kraj: anketa["endDate"]!)
                                self.glasanja.site.append(glasanje)
                                print(self.glasanja.site)
                                self.tableview.reloadData()
                            }
                        }
                    }
                }
                print(self.glasanja.site)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return glasanja.site.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "pollCell", for: indexPath) as! DetailsTableViewCell
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
        cell.questionTL?.text = self.glasanja.site[indexPath.row].prashanje //da zname na koj element sme
        cell.startDateTL?.text = "start: " + self.glasanja.site[indexPath.row].pocetok
        cell.endDateTL?.text = "end: " + self.glasanja.site[indexPath.row].kraj
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier:"votingPage")as? VotingViewController
        //let vc = storyboard?.instantiateViewController(withIdentifier: "votingPage) as? votingPage
        vc?.quest = glasanja.site[indexPath.row].prashanje
        print(vc?.quest as Any)
        vc!.modalPresentationStyle = .overFullScreen
        present(vc!, animated: true)
        //navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        try? Auth.auth().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier:"Login")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func unwindToFirstViewController(_ sender: UIStoryboardSegue) {
         // No code needed, no need to connect the IBAction explicitely
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
