//
//  ViewController1.swift
//  Paged
//
//  Created by Timothy Geissler on 6/29/18.
//  Copyright © 2018 Timothy Geissler. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController1: UIViewController, UITextViewDelegate {
    override var prefersStatusBarHidden: Bool { return true }
    @IBOutlet weak var label1: UITextView!
    @IBOutlet weak var timePicker1: UIDatePicker!
    @IBOutlet weak var timeButton1: UIButton!
    @IBOutlet weak var AlarmButton1: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    var seconds = 60 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    func StartTimer() {
        runTimer()
    }
    
    func StopTimer() {
        timer.invalidate()
        seconds = 60    //Here we manually enter the restarting point for the seconds, but it would be wiser to make this a variable or constant.
        timerLabel.text = "\(seconds)"
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController1.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        timerLabel.text = "\(seconds)" //This will update the label.
    }
    
    @IBAction func tapped1(_ sender: Any) {
        finishedEditing()
        self.timePicker1.isHidden = true
        self.timeButton1.isHidden = true
    }
    
    @IBAction func AlarmClicked1(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.AlarmButton1.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.AlarmButton1.transform = CGAffineTransform.identity
                        }
        })
        //Kill alarm
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                if notification.identifier == "UYLLocalNotification1" {
                    identifiers.append(notification.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
        StopTimer()
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.AlarmButton1.isHidden = true
        }
    }
    @IBAction func longPress1(_ sender: Any) {
        timePicker1.isHidden = false
        timeButton1.isHidden = false
    }
    
    @IBAction func timeButton1(_ sender: Any) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        self.timeButton1.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.timeButton1.transform = CGAffineTransform.identity
                        }
        })
        pushNotification(seconds: timePicker1.countDownDuration, body: label1.text)
        //delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.timePicker1.isHidden = true
            self.timeButton1.isHidden = true
        }
        //hide alarm button once notification is displayed
        DispatchQueue.main.asyncAfter(deadline: .now() + timePicker1.countDownDuration) {
            self.AlarmButton1.isHidden = true
        }
        StartTimer()
    }
    func pushNotification(seconds: Double, body: String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Don't forget!"
        content.body = body
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds,
                                                        repeats: false)
        let identifier = "UYLLocalNotification1"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                // Something went wrong
            }
        })
        AlarmButton1.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label1.delegate = self
        timePicker1.isHidden = true
        timeButton1.isHidden = true
        AlarmButton1.isHidden = true
        let data = UserDefaults.standard
        if (data.string(forKey: "txt1") == nil || data.string(forKey: "txt1") == "" || data.string(forKey: "txt1") == " ") {
            label1.text = "Here's a new reminder!"
        } else {
        label1.text = data.string(forKey: "txt1")
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
        label1.resignFirstResponder()
        let data = UserDefaults.standard
        data.set(label1.text, forKey: "txt1")
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
