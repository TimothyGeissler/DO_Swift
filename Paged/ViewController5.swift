//
//  ViewController5.swift
//  Paged
//
//  Created by Timothy Geissler on 6/29/18.
//  Copyright © 2018 Timothy Geissler. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController5: UIViewController, UITextViewDelegate {
    override var prefersStatusBarHidden: Bool { return true }
    @IBOutlet weak var label5: UITextView!
    @IBOutlet weak var timeButton5: UIButton!
    @IBOutlet weak var AlarmButton5: UIButton!
    @IBOutlet weak var timePicker5: UIDatePicker!
    
    @IBAction func AlarmClicked5(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.AlarmButton5.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.AlarmButton5.transform = CGAffineTransform.identity
                        }
        })
        //Kill alarm
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == "UYLLocalNotification5" {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.AlarmButton5.isHidden = true
        }
    }
    
    @IBAction func timeClicked5(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.timeButton5.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.timeButton5.transform = CGAffineTransform.identity
                        }
        })
        pushNotification(seconds: timePicker5.countDownDuration, body: label5.text)
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.timePicker5.isHidden = true
            self.timeButton5.isHidden = true
        }
        //hide alarm button once notification is displayed
        DispatchQueue.main.asyncAfter(deadline: .now() + timePicker5.countDownDuration) {
            self.AlarmButton5.isHidden = true
        }
    }
    
    @IBAction func longPress5(_ sender: Any) {
        timePicker5.isHidden = false
        timeButton5.isHidden = false
    }
    
    @IBAction func tapped5(_ sender: Any) {
        finishedEditing()
        self.timePicker5.isHidden = true
        self.timeButton5.isHidden = true
    }
    
    func pushNotification(seconds: Double, body: String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Don't forget!"
        content.body = body
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds,
                                                        repeats: false)
        let identifier = "UYLLocalNotification5"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                // Something went wrong
            }
        })
        AlarmButton5.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        label5.delegate = self
        self.AlarmButton5.isHidden = true
        self.timePicker5.isHidden = true
        self.timeButton5.isHidden = true
        let data = UserDefaults.standard
        if (data.string(forKey: "txt5") == nil || data.string(forKey: "txt5") == "" || data.string(forKey: "txt5") == " ") {
            label5.text = "Here's a new reminder!"
        } else {
            label5.text = data.string(forKey: "txt5")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            finishedEditing()
            return false
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func finishedEditing() {
        label5.resignFirstResponder()
        let data = UserDefaults.standard
        data.set(label5.text, forKey: "txt5")
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
