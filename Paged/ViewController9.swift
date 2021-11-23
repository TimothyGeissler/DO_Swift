//
//  ViewController9.swift
//  Paged
//
//  Created by Timothy Geissler on 6/29/18.
//  Copyright © 2018 Timothy Geissler. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController9: UIViewController, UITextViewDelegate {
    override var prefersStatusBarHidden: Bool { return true }
    @IBOutlet weak var label9: UITextView!
    @IBOutlet weak var timeButton9: UIButton!
    @IBOutlet weak var AlarmButton9: UIButton!
    @IBOutlet weak var timePicker9: UIDatePicker!
    @IBAction func AlarmClicked9(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.AlarmButton9.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.AlarmButton9.transform = CGAffineTransform.identity
                        }
        })
        //Kill alarm
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == "UYLLocalNotification9" {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.AlarmButton9.isHidden = true
        }
    }
    @IBAction func timeClicked9(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.timeButton9.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.timeButton9.transform = CGAffineTransform.identity
                        }
        })

        pushNotification(seconds: timePicker9.countDownDuration, body: label9.text)
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.timePicker9.isHidden = true
            self.timeButton9.isHidden = true
        }
        //hide alarm button once notification is displayed
        DispatchQueue.main.asyncAfter(deadline: .now() + timePicker9.countDownDuration) {
            self.AlarmButton9.isHidden = true
        }
    }
    @IBAction func longPress9(_ sender: Any) {
        timePicker9.isHidden = false
        timeButton9.isHidden = false
    }
    @IBAction func tapped9(_ sender: Any) {
        finishedEditing()
        self.timePicker9.isHidden = true
        self.timeButton9.isHidden = true
    }
    func pushNotification(seconds: Double, body: String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Don't forget!"
        content.body = body
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds,
                                                        repeats: false)
        let identifier = "UYLLocalNotification9"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                // Something went wrong
            }
        })
        AlarmButton9.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        label9.delegate = self
        self.timePicker9.isHidden = true
        self.timeButton9.isHidden = true
        self.AlarmButton9.isHidden = true
        let data = UserDefaults.standard
        if (data.string(forKey: "txt9") == nil || data.string(forKey: "txt9") == "" || data.string(forKey: "txt9") == " ") {
            label9.text = "Here's a new reminder!"
        } else {
            label9.text = data.string(forKey: "txt9")
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
        label9.resignFirstResponder()
        let data = UserDefaults.standard
        data.set(label9.text, forKey: "txt9")
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
