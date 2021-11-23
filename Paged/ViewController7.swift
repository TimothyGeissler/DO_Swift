//
//  ViewController7.swift
//  Paged
//
//  Created by Timothy Geissler on 6/29/18.
//  Copyright © 2018 Timothy Geissler. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController7: UIViewController, UITextViewDelegate {
    override var prefersStatusBarHidden: Bool { return true }
    @IBOutlet weak var label7: UITextView!
    @IBOutlet weak var AlarmButton7: UIButton!
    @IBOutlet weak var timePicker7: UIDatePicker!
    @IBOutlet weak var timeButton7: UIButton!
    @IBAction func AlarmClicked7(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.AlarmButton7.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.AlarmButton7.transform = CGAffineTransform.identity
                        }
        })
        //Kill alarm
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == "UYLLocalNotification7" {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.AlarmButton7.isHidden = true
        }
    }
    @IBAction func longPress7(_ sender: Any) {
        timePicker7.isHidden = false
        timeButton7.isHidden = false
    }
    @IBAction func timeClicked7(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.timeButton7.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.timeButton7.transform = CGAffineTransform.identity
                        }
        })
        pushNotification(seconds: timePicker7.countDownDuration, body: label7.text)
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.timePicker7.isHidden = true
            self.timeButton7.isHidden = true
        }
        //hide alarm button once notification is displayed
        DispatchQueue.main.asyncAfter(deadline: .now() + timePicker7.countDownDuration) {
            self.AlarmButton7.isHidden = true
        }
    }
    func pushNotification(seconds: Double, body: String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Don't forget!"
        content.body = body
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds,
                                                        repeats: false)
        let identifier = "UYLLocalNotification7"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                // Something went wrong
            }
        })
        AlarmButton7.isHidden = false
    }
    @IBAction func tapped7(_ sender: Any) {
        finishedEditing()
        self.timePicker7.isHidden = true
        self.timeButton7.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        label7.delegate = self
        self.timePicker7.isHidden = true
        self.timeButton7.isHidden = true
        self.AlarmButton7.isHidden = true
        let data = UserDefaults.standard
        if (data.string(forKey: "txt7") == nil || data.string(forKey: "txt7") == "" || data.string(forKey: "txt7") == " ") {
            label7.text = "Here's a new reminder!"
        } else {
            label7.text = data.string(forKey: "txt7")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            finishedEditing()
            return false
        }
        return true
    }
    
    func finishedEditing() {
        label7.resignFirstResponder()
        let data = UserDefaults.standard
        data.set(label7.text, forKey: "txt7")
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
