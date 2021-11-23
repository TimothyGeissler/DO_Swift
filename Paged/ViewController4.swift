//
//  ViewController4.swift
//  Paged
//
//  Created by Timothy Geissler on 6/29/18.
//  Copyright © 2018 Timothy Geissler. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController4: UIViewController, UITextViewDelegate {
    override var prefersStatusBarHidden: Bool { return true }
    @IBOutlet weak var AlarmButton4: UIButton!
    @IBOutlet weak var label4: UITextView!
    @IBOutlet weak var timeButton4: UIButton!
    @IBOutlet weak var timePicker4: UIDatePicker!
    
    @IBAction func AlarmClicked4(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.AlarmButton4.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.AlarmButton4.transform = CGAffineTransform.identity
                        }
        })
        //Kill alarm
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == "UYLLocalNotification4" {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.AlarmButton4.isHidden = true
        }
    }
    @IBAction func longPress4(_ sender: Any) {
        timePicker4.isHidden = false
        timeButton4.isHidden = false
    }
    @IBAction func tapped4(_ sender: Any) {
        finishedEditing()
        self.timePicker4.isHidden = true
        self.timeButton4.isHidden = true
    }
    @IBAction func timeClicked4(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.timeButton4.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.timeButton4.transform = CGAffineTransform.identity
                        }
        })
        pushNotification(seconds: timePicker4.countDownDuration, body: label4.text)
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.timePicker4.isHidden = true
            self.timeButton4.isHidden = true
        }
        //hide alarm button once notification is displayed
        DispatchQueue.main.asyncAfter(deadline: .now() + timePicker4.countDownDuration) {
            self.AlarmButton4.isHidden = true
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
        let identifier = "UYLLocalNotification4"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                // Something went wrong
            }
        })
        AlarmButton4.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        label4.delegate = self
        self.AlarmButton4.isHidden = true
        self.timePicker4.isHidden = true
        self.timeButton4.isHidden = true
        let data = UserDefaults.standard
        if (data.string(forKey: "txt4") == nil || data.string(forKey: "txt4") == "" || data.string(forKey: "txt4") == " ") {
            label4.text = "Here's a new reminder!"
        } else {
            label4.text = data.string(forKey: "txt4")
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
        label4.resignFirstResponder()
        let data = UserDefaults.standard
        data.set(label4.text, forKey: "txt4")
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
