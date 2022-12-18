//
//  AdminViewController.swift
//  PollingApp
//
//  Created by Emilija Chona on 12/15/22.
//

import UIKit
import FirebaseAuth

class AdminViewController: UIViewController,
                           UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableview: UITableView!
    
    var glasanja : [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.glasanja = ["Lokalni izbori", "Anketa za prisustvo",
        "Peticija za zatvaranje na zooloshkata"]
        
        self.tableview.dataSource = self
        self.tableview.delegate = self
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        try? Auth.auth().signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier:"Login")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
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
