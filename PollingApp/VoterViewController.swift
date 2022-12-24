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
    
    override func viewDidLoad() {
        getData()
        super.viewDidLoad()
        
        self.tableview.dataSource = self
        self.tableview.delegate = self
    }
    
    func getData() {
        ref.child("polls").observeSingleEvent(of: .value, with: { (snapshot) in
            
            print("There are \(snapshot.childrenCount) children found")

            if snapshot.childrenCount > 0 {

                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    if let data = data.value as? [String: String] {
                        
                        print(data)
                        let glasanje = zapis(prashanje: data["question"]!, pocetok: data["startDate"]!, kraj: data["endDate"]!)
                        self.glasanja.site.append(glasanje)
                        print(self.glasanja.site)
                        self.tableview.reloadData()
                    }
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return glasanja.site.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "pollCell", for: indexPath) as! DetailsTableViewCell
        
        cell.questionTL?.text = self.glasanja.site[indexPath.row].prashanje //da zname na koj element sme
        cell.startDateTL?.text = "start: " + self.glasanja.site[indexPath.row].pocetok
        cell.endDateTL?.text = "end: " + self.glasanja.site[indexPath.row].kraj
        
        return cell
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
