//
//  ViewController6.swift
//  Paged
//
//  Created by Timothy Geissler on 6/29/18.
//  Copyright © 2018 Timothy Geissler. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController6: UIViewController, UITextViewDelegate {
    override var prefersStatusBarHidden: Bool { return true }
    @IBOutlet weak var label6: UITextView!
    @IBOutlet weak var timePicker6: UIDatePicker!
    @IBOutlet weak var AlarmButton6: UIButton!
    @IBOutlet weak var timeButton6: UIButton!
    
    @IBAction func AlarmClicked6(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.AlarmButton6.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.AlarmButton6.transform = CGAffineTransform.identity
                        }
        })
        //Kill alarm
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == "UYLLocalNotification6" {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.AlarmButton6.isHidden = true
        }
    }
    @IBAction func longPress6(_ sender: Any) {
        timePicker6.isHidden = false
        timeButton6.isHidden = false
    }
    @IBAction func tapped6(_ sender: Any) {
        finishedEditing()
        self.timePicker6.isHidden = true
        self.timeButton6.isHidden = true
    }
    @IBAction func timeClicked6(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.timeButton6.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.timeButton6.transform = CGAffineTransform.identity
                        }
        })
        pushNotification(seconds: timePicker6.countDownDuration, body: label6.text)
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.timePicker6.isHidden = true
            self.timeButton6.isHidden = true
        }
        //hide alarm button once notification is displayed
        DispatchQueue.main.asyncAfter(deadline: .now() + timePicker6.countDownDuration) {
            self.AlarmButton6.isHidden = true
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
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                // Something went wrong
            }
        })
        AlarmButton6.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        label6.delegate = self
        self.timePicker6.isHidden = true
        self.timeButton6.isHidden = true
        self.AlarmButton6.isHidden = true
        let data = UserDefaults.standard
        if (data.string(forKey: "txt6") == nil || data.string(forKey: "txt6") == "" || data.string(forKey: "txt6") == " ") {
            label6.text = "Here's a new reminder!"
        } else {
            label6.text = data.string(forKey: "txt6")
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
        label6.resignFirstResponder()
        let data = UserDefaults.standard
        data.set(label6.text, forKey: "txt6")
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
