//
//  HomeScreenViewController.swift
//  AppointmentSystem
//
//  Created by omri azaria on 08/07/2021.
//

import UIKit
import FirebaseAuth
import Firebase


class DoctorScreenViewController: UIViewController {
    
    @IBOutlet weak var patientsTableView: UITableView!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var currentDoctoruid = Auth.auth().currentUser?.uid
    var selfDoctorPatients = [[String]]()
    var doctorsNames = [String]()
    var doctorName = String()
    var patients = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        
        patientsTableView.delegate = self
        patientsTableView.dataSource = self
    }
    
    func setUpElements(){
        selfDoctorPatients.removeAll()
        doctorsNames.removeAll()
        
        let db = Firestore.firestore()
        db.collection("doctors").whereField("uid", isEqualTo: currentDoctoruid!).getDocuments() { (querySnapshot, err) in
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                for document in querySnapshot!.documents {
                    self.selfDoctorPatients.append(document.data()["patients"] as? [String] ?? [])
                    self.doctorsNames.append(document.data()["fullname"] as? String ?? "")
                }
            }
            for array in self.selfDoctorPatients {
                self.patients = array
            }
            for name in self.doctorsNames {
                self.doctorName = name
            }
            self.welcomeLabel.text = "Hello, \(self.doctorName)"
            DispatchQueue.main.async {
                self.patientsTableView.reloadData()
            }
        }
    }
}



extension DoctorScreenViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension DoctorScreenViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = patients[indexPath.row]
        return cell
    }
}

