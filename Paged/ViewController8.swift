//
//  ViewController8.swift
//  Paged
//
//  Created by Timothy Geissler on 6/29/18.
//  Copyright © 2018 Timothy Geissler. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController8: UIViewController, UITextViewDelegate {
    override var prefersStatusBarHidden: Bool { return true }
    @IBOutlet weak var label8: UITextView!
    @IBOutlet weak var AlarmButton8: UIButton!
    @IBOutlet weak var timePicker8: UIDatePicker!
    @IBOutlet weak var timeButton8: UIButton!
    
    @IBAction func AlarmClicked8(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.AlarmButton8.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.AlarmButton8.transform = CGAffineTransform.identity
                        }
        })
        //Kill alarm
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == "UYLLocalNotification8" {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.AlarmButton8.isHidden = true
        }
    }
    @IBAction func longPress8(_ sender: Any) {
        timePicker8.isHidden = false
        timeButton8.isHidden = false
    }
    @IBAction func timeClicked8(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.timeButton8.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.timeButton8.transform = CGAffineTransform.identity
                        }
        })

        pushNotification(seconds: timePicker8.countDownDuration, body: label8.text)
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.timePicker8.isHidden = true
            self.timeButton8.isHidden = true
        }
        //hide alarm button once notification is displayed
        DispatchQueue.main.asyncAfter(deadline: .now() + timePicker8.countDownDuration) {
            self.AlarmButton8.isHidden = true
        }
    }
    @IBAction func tapped8(_ sender: Any) {
        finishedEditing()
        self.timePicker8.isHidden = true
        self.timeButton8.isHidden = true
    }
    func pushNotification(seconds: Double, body: String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Don't forget!"
        content.body = body
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds,
                                                        repeats: false)
        let identifier = "UYLLocalNotification8"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                // Something went wrong
            }
        })
        AlarmButton8.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        label8.delegate = self
        self.timePicker8.isHidden = true
        self.timeButton8.isHidden = true
        self.AlarmButton8.isHidden = true
        let data = UserDefaults.standard
        if (data.string(forKey: "txt8") == nil || data.string(forKey: "txt8") == "" || data.string(forKey: "txt8") == " ") {
            label8.text = "Here's a new reminder!"
        } else {
            label8.text = data.string(forKey: "txt8")
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
        label8.resignFirstResponder()
        let data = UserDefaults.standard
        data.set(label8.text, forKey: "txt8")
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
