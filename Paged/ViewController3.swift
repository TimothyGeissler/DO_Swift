//
//  ViewController3.swift
//  Paged
//
//  Created by Timothy Geissler on 6/29/18.
//  Copyright © 2018 Timothy Geissler. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController3: UIViewController, UITextViewDelegate {
    override var prefersStatusBarHidden: Bool { return true }
    @IBOutlet weak var AlarmButton3: UIButton!
    @IBOutlet weak var timePicker3: UIDatePicker!
    @IBOutlet weak var timeButton3: UIButton!
    @IBOutlet weak var label3: UITextView!
    
    @IBAction func AlarmClicked3(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.AlarmButton3.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.AlarmButton3.transform = CGAffineTransform.identity
                        }
        })
        //Kill alarm
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == "UYLLocalNotification3" {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.AlarmButton3.isHidden = true
        }
    }
    @IBAction func longPress3(_ sender: Any) {
        timePicker3.isHidden = false
        timeButton3.isHidden = false
    }
    @IBAction func tapped3(_ sender: Any) {
        finishedEditing()
        self.timePicker3.isHidden = true
        self.timeButton3.isHidden = true
    }
    @IBAction func timeClicked3(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.timeButton3.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.timeButton3.transform = CGAffineTransform.identity
                        }
        })
        pushNotification(seconds: timePicker3.countDownDuration, body: label3.text)
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.timePicker3.isHidden = true
            self.timeButton3.isHidden = true
        }
        //hide alarm button once notification is displayed
        DispatchQueue.main.asyncAfter(deadline: .now() + timePicker3.countDownDuration) {
            self.AlarmButton3.isHidden = true
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
        let identifier = "UYLLocalNotification3"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                // Something went wrong
            }
        })
        AlarmButton3.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label3.delegate = self
        self.timePicker3.isHidden = true
        self.AlarmButton3.isHidden = true
        self.timeButton3.isHidden = true
        let data = UserDefaults.standard
        if (data.string(forKey: "txt3") == nil || data.string(forKey: "txt3") == "" || data.string(forKey: "txt3") == " ") {
            label3.text = "Here's a new reminder!"
        } else {
            label3.text = data.string(forKey: "txt3")
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
        label3.resignFirstResponder()
        let data = UserDefaults.standard
        data.set(label3.text, forKey: "txt3")
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
