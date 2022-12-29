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
    let currentDateTime = Date()
    let formatter = DateFormatter()
    
    
    override func viewDidLoad() {
        ref.child("users/\(currUserID)/name").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.userName = snapshot?.value as! String;
            print(self.userName)
        });
        
        formatter.dateFormat = "E, dd MMM yyyy HH:mm"
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
                        if data["adminName"] == self.userName {
                            let glasanje = zapis(prashanje: data["question"]!, pocetok: data["startDate"]!, kraj: data["endDate"]!)
                            self.glasanja.site.append(glasanje)
                            self.tableview.reloadData()
                        }
                    }
                }
                print(self.glasanja.site)
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
    
    func stringToDate() {
        let dateFormatter = DateFormatter()
          dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
          dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm"
          let date = dateFormatter.date(from:"Wed, 28 Dec 2022 12:00")!
        if date == self.currentDateTime {
            
        }
    }
    
    //MARK: Datasource
    
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
        if glasanja.site[indexPath.row].status == 0 {
            //ako ne e zapocnato
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier:"detailsView")as? DetailsViewController
            vc?.question = glasanja.site[indexPath.row].prashanje
            vc?.startDate = glasanja.site[indexPath.row].pocetok
            vc?.endDate = glasanja.site[indexPath.row].kraj
            vc!.modalPresentationStyle = .overFullScreen
            present(vc!, animated: true)
        }else if glasanja.site[indexPath.row].status == 2{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier:"adminResults")as? DetailsViewController //AdminResultsViewController !!!
            vc?.question = glasanja.site[indexPath.row].prashanje
            vc?.startDate = glasanja.site[indexPath.row].pocetok
            vc?.endDate = glasanja.site[indexPath.row].kraj
            vc!.modalPresentationStyle = .overFullScreen
            present(vc!, animated: true)
        }
    }

}
