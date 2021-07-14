//
//  SignUpViewController.swift
//  AppointmentSystem
//
//  Created by omri azaria on 08/07/2021.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {

    @IBOutlet weak var fullNameTextField: UITextField!
    
    @IBOutlet weak var patientOrDoctorSegmetedControl: UISegmentedControl!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.backgroundColor = UIColor.systemTeal
        signUpButton.layer.cornerRadius = 25.0
        signUpButton.tintColor = UIColor.white
        setUpElements()
    }
    
    func setUpElements(){
        errorLabel.alpha = 0
    }
    
    func validateFields() -> String? {
        
        if (fullNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "")
        {
            return "Please fill valid information"
        }
        
        if !isPasswordValid((passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!){
            
            return "Please enter a strong password"
            
        }
        return nil
    }
    
    func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    @IBAction func singUpTapped(_ sender: Any) {
        var isDoctor = false
        let error = validateFields()
        let db = Firestore.firestore()
        if error != nil
        {
            showError(error!)
        }
        else
        {
            let fullName = fullNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if (patientOrDoctorSegmetedControl.selectedSegmentIndex == 0){
                isDoctor = true
            }
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                let uid = result!.user.uid
                if err != nil
                {
                    self.showError("User creation failed")
                }
                else
                {
                    if isDoctor == true
                    {
                        let drFullName = "Dr. \(fullName)"
                        db.collection("doctors").document(uid).setData(["email":email, "fullname":drFullName, "password":password, "isavailable":true, "patients":[], "uid":uid]) { error in
                            if error != nil
                            {
                                self.showError("Firestore error")
                            }
                        }
                        self.transitionToLogInScreen()
                    }
                    else
                    {
                        db.collection("patients").document(uid).setData( ["email":email, "fullname":fullName, "password":password, "uid":result!.user.uid]) { error in
                            
                            if error != nil
                            {
                                self.showError("Firestore error")
                            }
                        }
                        self.transitionToLogInScreen()
                    }
                }
            }
            
        }
    }
    
    func transitionToLogInScreen(){
        let logInViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.LogInViewController) as? LogInViewController

        view.window?.rootViewController = logInViewController
        view.window?.makeKeyAndVisible()
    }
    
    func showError(_ message:String) {
        errorLabel.alpha = 1
        errorLabel.text = message
    }
}
