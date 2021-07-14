//
//  DoctorInfoViewController.swift
//  AppointmentSystem
//
//  Created by omri azaria on 11/07/2021.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import UserNotifications


var doctorPatients = [String]()
var doctorQueue = [Timestamp]()
let uuidString = UUID().uuidString



class DoctorInfoViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var cancelAppointmentButton: UIButton!
    
    @IBOutlet weak var makeAppointmentButton: UIButton!
    
    @IBOutlet weak var PatientsListTableView: UITableView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var nextAvailableAppointment: UILabel!
    
    var doctorPatients = selectDoctorpatients[myIndex]
    var doctorQueue = doctorTimetable[myIndex]
    var doctorAvailable = isAvailable[myIndex]
    let db = Firestore.firestore()
    var patientCurrentTime = Timestamp.init(date: Date())
    var notificationLogic = NotificationLogic()
    
    
    override func viewDidLoad() {
        setUpElements()
        super.viewDidLoad()
        
        PatientsListTableView.delegate = self
        PatientsListTableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpElements(){
        makeAppointmentButton.backgroundColor = UIColor.systemBlue
        makeAppointmentButton.layer.cornerRadius = 25.0
        makeAppointmentButton.tintColor = UIColor.white
        
        cancelAppointmentButton.backgroundColor = UIColor.systemRed
        cancelAppointmentButton.layer.cornerRadius = 25.0
        cancelAppointmentButton.tintColor = UIColor.white
        
        nameLabel.text = names[myIndex]
        errorLabel.alpha = 0

        for date in doctorQueue
        {
            if(Date() > date.dateValue())
            {
                removeThisAppointemnt(timestamp: date)
            }
        }
        if (doctorQueue.count > 0)
        {
            patientCurrentTime = Timestamp.init(date: doctorQueue[0].dateValue().adding(minutes: ((doctorQueue.count) * 10)))
        }
        else
        {
            patientCurrentTime = Timestamp.init(date: Date().adding(minutes: 10))
            updateavailability(bool: true)
        }
        
        let availableAppointment = patientCurrentTime.dateValue().adding(minutes: -10)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm d,MMM,YYYY"
        nextAvailableAppointment.text = "The next available appointment is at  \(dateFormatter.string(from: availableAppointment))"
    }
    
    
    func updateavailability(bool: Bool){
        doctorAvailable = bool
        db.collection("doctors").whereField("fullname", isEqualTo: names[myIndex]).getDocuments() { (querySnapshot, err) in
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                querySnapshot!.documents.first?.reference.updateData(["isavailable": bool])
            }
        }
    }
    
    func removeThisAppointemnt(timestamp:Timestamp){
        if let index = doctorQueue.firstIndex(of: timestamp)
        {
            let patient = doctorPatients[index]
            doctorQueue.remove(at: index)
            doctorPatients.remove(at: index)
            db.collection("doctors").document(doctorsdUid[myIndex]).updateData([
                "patients": FieldValue.arrayRemove([patient]),
                "timetable": FieldValue.arrayRemove([timestamp])
            ]) { err in
                if let err = err
                {
                    print("Error updating document: \(err)")
                }
                else
                {
                    print("Document successfully updated")
                }
                DispatchQueue.main.async {
                    self.PatientsListTableView.reloadData()
                }
            }
        }
    }
    
    func setUpNotification()
    {
        if (doctorQueue.count == 1)
        {
            showAlert()
        }
        else
        {
            var date = patientCurrentTime.dateValue()
            if (doctorQueue.count == 1)
            {
                date = Date().adding(seconds: 2)
            }
            notificationLogic.setUpNotification(date: date)
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "AppointmentSystem", message: "Your appointment starts now, Please enter the doctor's room", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    @IBAction func makeAppointmentTapped(_ sender: Any) {
        if (doctorPatients.firstIndex(of: patientName) != nil)
        {
            errorLabel.alpha = 1
            errorLabel.text = "The request could not be completed, there is a meeting in the system"
        }
        else
        {
            errorLabel.alpha = 0
            doctorPatients.append(patientName)
            doctorQueue.append(patientCurrentTime)
            db.collection("doctors").whereField("fullname", isEqualTo: names[myIndex]).getDocuments() { (querySnapshot, err) in
                if let err = err
                {
                    print("Error getting documents: \(err)")
                }
                else
                {
                    querySnapshot!.documents.first?.reference.updateData(["patients" : self.doctorPatients])
                    querySnapshot!.documents.first?.reference.updateData(["timetable" : self.doctorQueue])
                }
                DispatchQueue.main.async {
                    self.PatientsListTableView.reloadData()
                }
            }
            if (doctorAvailable)
            {
                updateavailability(bool: false)
            }
            setUpNotification()
            NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
        }
    }
    
    @IBAction func cancelAppointmentTapped(_ sender: Any) {
        if let index = doctorPatients.firstIndex(of: patientName){
            patientCurrentTime = doctorQueue[index]
            errorLabel.alpha = 0
            doctorQueue.remove(at: index)
            doctorPatients.remove(at: index)
            db.collection("doctors").document(doctorsdUid[myIndex]).updateData([
                "patients": FieldValue.arrayRemove([patientName]),
                "timetable": FieldValue.arrayRemove([patientCurrentTime])
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            DispatchQueue.main.async {
                self.PatientsListTableView.reloadData()
            }
            if(doctorQueue.count == 0){
                updateavailability(bool: true)
            }
            notificationLogic.cancelNotification()
            NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
        }
        else
        {
            errorLabel.alpha = 1
            errorLabel.text = "The request could not be completed, there is no meeting in the system"
        }
    }
}


extension DoctorInfoViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension DoctorInfoViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctorPatients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = doctorPatients[indexPath.row]
        return cell
    }

}

extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    func adding(seconds: Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: seconds, to: self)!
    }
}
