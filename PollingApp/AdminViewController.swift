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
//    var glasanja : [String]!
    var glasanja = ["example"]
    
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
                    if let data = data.value as? [String: Any] {
                        
                        print(data)
                        print(data["question"] as Any)
                        self.glasanja.append(data["question"] as? String ?? "N/A")
                        print(self.glasanja)
                        self.tableview.reloadData()
                    }
                }
            }
        })
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
    
    //MARK: Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.glasanja.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "pollCell")!
        
        cell.textLabel?.text = self.glasanja[indexPath.row] //da zname na koj element sme
        
        return cell
    }

}
