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
