//
//  LockScreenViewController.swift
//  AnimalKingdom
//
//  Created by Tom Riddle on 11/26/20.
//

import UIKit

class LockScreenViewController: UIViewController {
    var data: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = 100
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        //notificationCenter.addObserver(self, selector: #selector(appWillTerminate), name: UIApplication.willTerminateNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appComeToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background")
        let alert = UIAlertController(title: "Do you want to leave the app?", message: "If you leave the app, you progress will be cancelled", preferredStyle: .alert)
        //if yes, stop the clock, 
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
}
