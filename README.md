# AppointmentSystem

appointment system management app for doctors using Firebase Database.

**System requirements:**
* Login screen:  Doctor / patient
* Signup screen: Doctor / patient

**Patient:**
- Can view a list of doctors with an option to filter by their availability
- Make an appointment:
  - Choose a doctor
  - If the doctor is available, the patient will receive a notification.
  - If the doctor is unavailable, the patient will be added to the doctor’swaiting list. Once his appointment arrived, he will receive a notification.
    - He will be able to cancel the appointment - as long as he hasn’treceived a notification that his appointment has arrived
    - He will be able to see the waiting list.

**Doctor:**
- Can view a list of waiting patients sorted by arrival time.
- If the doctor is available, the patient will be treated immediately,  else he will beadded to the waiting list.
- Once the doctor receives a patient - he will be occupied for 10 minutes. And as soonas he finishes, he will receive the next patient.





### **description**

When the user enters the system for the first time, the system will ask him for a permission to get notifications, so that we can send the user notifications.
At the login screen, the user has 2 options - to sign up to the system or to log in. Each one of them leads to a different screen.

**SignUpViewController**

The user has to fill in the following: full name, user type (Doctor or Patient), email address and password.When the user presses the registration button, the system will ensure that the inputs are valid. 
If the inputs aren’t valid, an error will appear to the user.
If the user inputs are correct, the system will add the user’s email and password to Google Authentication (a system which ensures that the user is signed up to the system, and checks if the email and the password are compatible with the user). In addition, the system storages the info of the user at Google Firestore Database (a system which saves the data we decide to storage) at two collection types: doctors and patients, according to the user type. The user has the option to go back to the main screen of the system.


**LogInViewController**

the user enters the email and the password he signed up with, and chooses his user type, the system ensures that the inputs are valid. If the inputs aren’t valid, an error will show up on the screen. If the inputs are valid, the system will send a request to Google Authentication. If the user details are correct, we’ll get his UID back. According to the UID, we will check if the user registered as a Doctor or as a Patients using Google Firestore Database, If the user type is correct the system will switch to the user screen (Doctor screen and Patient screen).

**DoctorScreenViewController**

Using the uid, we get the information about the doctor’s waiting list and the doctor's name by sending a request to Google Firestore Database. The system will display the doctor’s waiting list in Table View and the doctor's name at the top of the screen.

**PatientScreenViewController**

We will receive information about the doctors registered in the system (names, availability, waiting list, schedule, uid) and information about the patient (name and uid) using Google Firestore Database. We will present the doctor's list to the patients. In addition, the patient has the option to filter only available doctors. When the patient selects this option will send a request to Google Firestore Database when the doctor "availability" field is "true". When the patient chooses a doctor, the DoctorInfoViewController will appear.

**DoctorInfoViewController**

This screen displays the name of the selected doctor in the top of the screen, the doctor’s waiting list, information about the next available appointment, the "Make an appointment" button and the "Cancel an appointment" button.
When the screen appears the system checks which patients already got the treatment, updates the next available appointment and the availability of the doctor. After the update, the doctor’s waiting list and the next available appointment are presented to the client. 
When the patient taps on the "Make an appointment" button there are two options. The first option is when the doctor is available, so after making an appointment his availability will change. In this case, a message will pop that the appointment has arrived. The second option is when the doctor is not available, he will get register notification upon the arrival of the appointment. In both cases we will add the client to the doctor's patient list in the Google Firestore Database, the next available appointment will be set for the next 10 minutes, and the PatientScreenViewController reload.
When the patient taps on the "Cancel an appointment" button, the system updates the availability of the doctor, remove the patient from the doctor's patient list in the Google Firestore Database, cancel the register notification, and the PatientScreenViewController reload. If the system get an error when the patient taps on "Make an appointment" button or "cancel an appointment" button, the error will appear to the patient.













