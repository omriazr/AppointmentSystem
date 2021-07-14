//
//  LogInViewController.swift
//  AppointmentSystem
//
//  Created by omri azaria on 08/07/2021.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase


class LogInViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var isDoctorSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInButton.backgroundColor = UIColor.systemBlue
        logInButton.layer.cornerRadius = 25.0
        logInButton.tintColor = UIColor.white
        setUpElements()
    }
    
    func setUpElements(){
        errorLabel.alpha = 0
    }
    
    func validateFields() -> String? {
        
        if  (emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            return "Please fill valid information"
        }
        return nil
    }
    
    
    @IBAction func logInTapped(_ sender: Any) {
        var isDoctor = false
        let db = Firestore.firestore()
        
        let error = validateFields()
        
        if error != nil
        {
            showError(error!)
        }
        else
        {
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if (isDoctorSegmentedControl.selectedSegmentIndex == 0)
            {
                isDoctor = true
            }
            Auth.auth().signIn(withEmail: email, password: password) { result, err in
                
                if err != nil
                {
                    self.errorLabel.alpha = 1
                    self.errorLabel.text = err!.localizedDescription
                }
                else
                {
                    if (isDoctor){
                        let docRef = db.collection("doctors").document(result?.user.uid ?? "")

                        docRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                let doctorScreenViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.DoctorScreenViewController) as? DoctorScreenViewController
                                
                                    self.view.window?.rootViewController = doctorScreenViewController
                                self.view.window?.makeKeyAndVisible()
                                
                            }
                            else
                            {
                                self.errorLabel.alpha = 1
                                self.errorLabel.text = "Sorry, are you a doctor?"
                            }
                        }
                    }
                    else
                    {
                        let docRef = db.collection("patients").document(result?.user.uid ?? "")
                        docRef.getDocument { (document, error) in
                            if let document = document, document.exists {
                                let patientScreenViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.PatientScreenViewController) as? PatientScreenViewController
                                self.view.window?.rootViewController = patientScreenViewController
                                self.view.window?.makeKeyAndVisible()
                                
                            }
                            else
                            {
                                self.errorLabel.alpha = 1
                                self.errorLabel.text = "Sorry, are you a patient?"
                            }
                        }
                    }
                }
            }
        }
    }
    
    func showError(_ message:String) {
        errorLabel.alpha = 1
        errorLabel.text = message
    }
    

}
