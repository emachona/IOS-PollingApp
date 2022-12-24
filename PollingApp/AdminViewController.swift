//
//  AdminViewController.swift
//  PollingApp
//
//  Created by Emilija Chona on 12/15/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AdminViewController: UIViewController,
                           UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableview: UITableView!
    private let ref = Database.database().reference()
    let currUserID : String = (Auth.auth().currentUser?.uid)!
    var userName = "Admin"
    var glasanja = model()

    override func viewDidLoad() {
        ref.child("users/\(currUserID)/name").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.userName = snapshot?.value as! String;
            print(self.userName)
        });
        
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
                        if data["adminName"] == self.userName {
                            let glasanje = zapis(prashanje: data["question"]!, pocetok: data["startDate"]!, kraj: data["endDate"]!)
                            self.glasanja.site.append(glasanje)
                            print(self.glasanja.site)
                            self.tableview.reloadData()
                        }
                    }
                }
            }
        })
    }
    
//    override func prepare(for seq: UIStoryboardSeque, sender: Any?){ if seg.identifier = “detailsSegue” {
//        if let index = tableView.indexParhForSelectedRow?.row {
//            let destVC = seq.destination as! DetailsViewController destVC.itemT = model.allItems[index]
//            }
//       }
//    }

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
    
    //MARK: Datasource
    
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

}
