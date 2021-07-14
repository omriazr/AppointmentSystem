//
//  PatientScreenViewController.swift
//  AppointmentSystem
//
//  Created by omri azaria on 09/07/2021.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import UserNotifications

var names = [String]()
var isAvailable = [Bool]()
var onlyAvailable = false
var myIndex = 1
var selectDoctorpatients = [[String]]()
var patientName = ""
var doctorsdUid = [String]()
var doctorTimetable = [[Timestamp]]()

class PatientScreenViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var doctorsTableView: UITableView!
    
    @IBOutlet weak var availableSwitch: UILabel!
    
    @IBOutlet weak var showAvailableLabel: UILabel!
    
    var patientUid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        getPatientInfo()
        doctorsTableView.delegate = self
        doctorsTableView.dataSource = self
        
        welcomeLabel.text = "Welcome, Please choose a doctor"
        showAvailableLabel.tintColor = UIColor.systemBlue
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name("reload"), object: nil)
    }
    
    func setUpElements(){
        
        names.removeAll()
        isAvailable.removeAll()
        selectDoctorpatients.removeAll()
        doctorsdUid.removeAll()
        doctorTimetable.removeAll()
        
        let db = Firestore.firestore()
        if (!onlyAvailable)
        {
            db.collection("doctors").getDocuments() { (querySnapshot, err) in
                if let err = err
                {
                    print("Error getting documents: \(err)")
                }
                else
                {
                    for document in querySnapshot!.documents {
                        names.append(document.data()["fullname"] as? String ?? "")
                        isAvailable.append(document.data()["isavailable"] as? Bool ?? false)
                        selectDoctorpatients.append(document.data()["patients"] as? [String] ?? [])
                        doctorsdUid.append(document.data()["uid"] as? String ?? "")
                        doctorTimetable.append(document.data()["timetable"] as? [Timestamp] ?? [])
                    }
                }
                DispatchQueue.main.async {
                    self.doctorsTableView.reloadData()
                }
            }
        }
        else
        {
            db.collection("doctors").whereField("isavailable", isEqualTo: true).getDocuments() { (querySnapshot, err) in
                if let err = err
                {
                    print("Error getting documents: \(err)")
                }
                else
                {
                    for document in querySnapshot!.documents {
                        names.append(document.data()["fullname"] as? String ?? "")
                        isAvailable.append(document.data()["isavailable"] as? Bool ?? false)
                        selectDoctorpatients.append(document.data()["patients"] as? [String] ?? [])
                        doctorsdUid.append(document.data()["uid"] as? String ?? "")
                        doctorTimetable.append(document.data()["timetable"] as? [Timestamp] ?? [])
                    }
                }
                DispatchQueue.main.async {
                    self.doctorsTableView.reloadData()
                }
            }
        }
    }

    
    @objc func reload(notification: NSNotification) {
        setUpElements()
        DispatchQueue.main.async {
            self.doctorsTableView.reloadData()
        }
    }

    func getPatientInfo(){
        Firestore.firestore().collection("patients").whereField("uid", isEqualTo: patientUid!).getDocuments(){ (querySnapshot, err) in
            if err == nil
            {
                for document in querySnapshot!.documents {
                    patientName = document.get("fullname") as! String
                }
            }
        }
    }
    
    @IBAction func switchChange(_ sender: Any) {
        if ((sender as AnyObject).isOn == true)
        {
            onlyAvailable = true
        }
        else
        {
            onlyAvailable = false
        }
        setUpElements()
    }
}

extension PatientScreenViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }
}

extension PatientScreenViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(names[indexPath.row])"
        return cell
    }
}

