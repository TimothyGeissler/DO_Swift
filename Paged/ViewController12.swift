//
//  ViewController12.swift
//  Paged
//
//  Created by Timothy Geissler on 6/29/18.
//  Copyright © 2018 Timothy Geissler. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController12: UIViewController, UITextViewDelegate {
    override var prefersStatusBarHidden: Bool { return true }
    @IBOutlet weak var label12: UITextView!
    @IBOutlet weak var AlarmButton12: UIButton!
    @IBOutlet weak var timeButton12: UIButton!
    @IBOutlet weak var timePicker12: UIDatePicker!
    
    @IBAction func AlarmClicked12(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.AlarmButton12.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.AlarmButton12.transform = CGAffineTransform.identity
                        }
        })
        //Kill alarm
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == "UYLLocalNotification12" {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.AlarmButton12.isHidden = true
        }
    }
    @IBAction func timeClicked12(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.timeButton12.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.timeButton12.transform = CGAffineTransform.identity
                        }
        })
        
        pushNotification(seconds: timePicker12.countDownDuration, body: label12.text)
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.timePicker12.isHidden = true
            self.timeButton12.isHidden = true
        }
        //hide alarm button once notification is displayed
        DispatchQueue.main.asyncAfter(deadline: .now() + timePicker12.countDownDuration) {
            self.AlarmButton12.isHidden = true
        }
    }
    @IBAction func longPress12(_ sender: Any) {
        timePicker12.isHidden = false
        timeButton12.isHidden = false
    }
    @IBAction func tapped12(_ sender: Any) {
        finishedEditing()
        self.timePicker12.isHidden = true
        self.timeButton12.isHidden = true
    }
    func pushNotification(seconds: Double, body: String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Don't forget!"
        content.body = body
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds,
                                                        repeats: false)
        let identifier = "UYLLocalNotification12"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                // Something went wrong
            }
        })
        AlarmButton12.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        label12.delegate = self
        self.timePicker12.isHidden = true
        self.timeButton12.isHidden = true
        self.AlarmButton12.isHidden = true
        let data = UserDefaults.standard
        if (data.string(forKey: "txt12") == nil || data.string(forKey: "txt12") == "" || data.string(forKey: "txt12") == " ") {
            label12.text = "Here's a new reminder!"
        } else {
            label12.text = data.string(forKey: "txt12")
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
        label12.resignFirstResponder()
        let data = UserDefaults.standard
        data.set(label12.text, forKey: "txt12")
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
