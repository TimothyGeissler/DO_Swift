//
//  ViewController11.swift
//  Paged
//
//  Created by Timothy Geissler on 6/29/18.
//  Copyright © 2018 Timothy Geissler. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController11: UIViewController, UITextViewDelegate {
    override var prefersStatusBarHidden: Bool { return true }
    @IBOutlet weak var label11: UITextView!
    @IBOutlet weak var timePicker11: UIDatePicker!
    @IBOutlet weak var timeButton11: UIButton!
    @IBOutlet weak var AlarmButton11: UIButton!
    

    @IBAction func AlarmClicked11(_ sender: Any) {
    UIView.animate(withDuration: 0.1,
                   animations: {
                    self.AlarmButton11.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    },
                   completion: { _ in
                    UIView.animate(withDuration: 0.6) {
                        self.AlarmButton11.transform = CGAffineTransform.identity
                    }
    })
    //Kill alarm
    UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
        var identifiers: [String] = []
        for notification:UNNotificationRequest in notificationRequests {
            if notification.identifier == "UYLLocalNotification11" {
                identifiers.append(notification.identifier)
            }
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    //delay
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
        self.AlarmButton11.isHidden = true
    }
    }
    @IBAction func tapped11(_ sender: Any) {
        finishedEditing()
        timePicker11.isHidden = true
        timeButton11.isHidden = true
    }
    @IBAction func timeClicked11(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.timeButton11.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.timeButton11.transform = CGAffineTransform.identity
                        }
        })
        pushNotification(seconds: timePicker11.countDownDuration, body: label11.text)
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.timePicker11.isHidden = true
            self.timeButton11.isHidden = true
        }
        //hide alarm button once notification is displayed
        DispatchQueue.main.asyncAfter(deadline: .now() + timePicker11.countDownDuration) {
            self.AlarmButton11.isHidden = true
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
        let identifier = "UYLLocalNotification11"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                // Something went wrong
            }
        })
        AlarmButton11.isHidden = false
    }
    @IBAction func longPress11(_ sender: Any) {
        timePicker11.isHidden = false
        timeButton11.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        label11.delegate = self
        timePicker11.isHidden = true
        timeButton11.isHidden = true
        self.AlarmButton11.isHidden = true
        let data = UserDefaults.standard
        if (data.string(forKey: "txt11") == nil || data.string(forKey: "txt11") == "" || data.string(forKey: "txt11") == " ") {
            label11.text = "Here's a new reminder!"
        } else {
            label11.text = data.string(forKey: "txt11")
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
        label11.resignFirstResponder()
        let data = UserDefaults.standard
        data.set(label11.text, forKey: "txt11")
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
