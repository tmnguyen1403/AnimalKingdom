//
//  LockScreenViewController.swift
//  AnimalKingdom
//
//  Created by Tom Riddle on 11/26/20.
//

import UIKit

class LockScreenViewController: UIViewController {
    var data: Int!
    var timeLimitInSecond : Double = 10.0
    
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        completeButton.isEnabled = false
        data = 100
        //check if user leave the app
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        //notificationCenter.addObserver(self, selector: #selector(appWillTerminate), name: UIApplication.willTerminateNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appComeToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        //start timer
        HelperTimer.setStartTime()
        HelperTimer.createStartTimer{
            self.startTimeLabel.text = HelperTimer.updateTimer()
            if HelperTimer.didWaitTimePass(second: self.timeLimitInSecond) {
                print("You animal is hatched")
                //update UI
                self.completeButton.isEnabled = true
                HelperTimer.destroyTimer()
            }
        }
        //endTime
        endTimeLabel.text = "00:00:\(timeLimitInSecond)"
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background")
        let alert = UIAlertController(title: "Do you want to leave the app?", message: "If you leave the app, you progress will be cancelled", preferredStyle: .alert)
        //if yes, stop the clock, 
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: {
            HelperTimer.destroyTimer()
            HelperTimer.setStartTime()
        })
        print("Your current progress \(String(describing: data))")
        data = 1
    }
    
//    @objc func appWillTerminate() {
//        print("App will terminate")
//        let alert = UIAlertController(title: "Do you want to close the app?", message: "If you close the app, you progress will be cancelled", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
//        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
    
    @objc func appComeToForeground() {
        print("Your current progress \(String(describing: data))")
        print("App come to foreground")
        let alert = UIAlertController(title: "Welcome back", message: "Do you want to incubate the same animal?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onComplete(_ sender: Any) {
        print("onComplete - add the new animal to user achievements")
        // MARK: DEMO
    }
    
}
