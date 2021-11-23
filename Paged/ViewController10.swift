//
//  ViewController10.swift
//  Paged
//
//  Created by Timothy Geissler on 6/29/18.
//  Copyright © 2018 Timothy Geissler. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController10: UIViewController, UITextViewDelegate {
    override var prefersStatusBarHidden: Bool { return true }
    @IBOutlet weak var timeButton10: UIButton!
    @IBOutlet weak var label10: UITextView!
    @IBOutlet weak var AlarmButton10: UIButton!
    @IBOutlet weak var timePicker10: UIDatePicker!
    
    @IBAction func AlarmClicked10(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.AlarmButton10.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.AlarmButton10.transform = CGAffineTransform.identity
                        }
        })
        //Kill alarm
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == "UYLLocalNotification10" {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.AlarmButton10.isHidden = true
        }
    }
    @IBAction func tapped10(_ sender: Any) {
        finishedEditing()
        self.timePicker10.isHidden = true
        self.timeButton10.isHidden = true
    }
    @IBAction func longPress10(_ sender: Any) {
        timePicker10.isHidden = false
        timeButton10.isHidden = false
    }
    @IBAction func timeClicked10(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.timeButton10.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.timeButton10.transform = CGAffineTransform.identity
                        }
        })

        pushNotification(seconds: timePicker10.countDownDuration, body: label10.text)
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.timePicker10.isHidden = true
            self.timeButton10.isHidden = true
        }
        //hide alarm button once notification is displayed
        DispatchQueue.main.asyncAfter(deadline: .now() + timePicker10.countDownDuration) {
            self.AlarmButton10.isHidden = true
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
        let identifier = "UYLLocalNotification10"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                // Something went wrong
            }
        })
        AlarmButton10.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        label10.delegate = self
        self.timePicker10.isHidden = true
        self.timeButton10.isHidden = true
        self.AlarmButton10.isHidden = true
        let data = UserDefaults.standard
        if (data.string(forKey: "txt10") == nil || data.string(forKey: "txt10") == "" || data.string(forKey: "txt10") == " ") {
            label10.text = "Here's a new reminder!"
        } else {
            label10.text = data.string(forKey: "txt10")
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
        label10.resignFirstResponder()
        let data = UserDefaults.standard
        data.set(label10.text, forKey: "txt10")
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
