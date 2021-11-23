//
//  ViewController2.swift
//  Paged
//
//  Created by Timothy Geissler on 6/29/18.
//  Copyright © 2018 Timothy Geissler. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController2: UIViewController, UITextViewDelegate {
    override var prefersStatusBarHidden: Bool { return true }
    @IBOutlet weak var AlarmButton2: UIButton!
    @IBOutlet weak var label2: UITextView!
    @IBOutlet weak var timePicker2: UIDatePicker!
    @IBOutlet weak var timeButton2: UIButton!
    
    @IBAction func AlarmClicked2(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.AlarmButton2.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.AlarmButton2.transform = CGAffineTransform.identity
                        }
        })
        //Kill alarm
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == "UYLLocalNotification2" {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.AlarmButton2.isHidden = true
        }
    }
    @IBAction func timeButtonClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.timeButton2.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.timeButton2.transform = CGAffineTransform.identity
                        }
        })
        pushNotification(seconds: timePicker2.countDownDuration, body: label2.text)
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.timePicker2.isHidden = true
            self.timeButton2.isHidden = true
        }
        //hide alarm button once notification is displayed
        DispatchQueue.main.asyncAfter(deadline: .now() + timePicker2.countDownDuration) {
            self.AlarmButton2.isHidden = true
        }
    }
    
    @IBAction func tapped2(_ sender: Any) {
        finishedEditing()
        self.timePicker2.isHidden = true
        self.timeButton2.isHidden = true
    }
    
    @IBAction func longPress2(_ sender: Any) {
        timePicker2.isHidden = false
        timeButton2.isHidden = false
    }
    
    func pushNotification(seconds: Double, body: String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Don't forget!"
        content.body = body
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds,
                                                        repeats: false)
        let identifier = "UYLLocalNotification2"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                // Something went wrong
            }
        })
        AlarmButton2.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timePicker2.isHidden = true
        self.timeButton2.isHidden = true
        self.AlarmButton2.isHidden = true
        label2.delegate = self
        let data = UserDefaults.standard
        if (data.string(forKey: "txt2") == nil || data.string(forKey: "txt2") == "" || data.string(forKey: "txt2") == " ") {
            label2.text = "Here's a new reminder!"
        } else {
            label2.text = data.string(forKey: "txt2")
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
        label2.resignFirstResponder()
        let data = UserDefaults.standard
        data.set(label2.text, forKey: "txt2")
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
