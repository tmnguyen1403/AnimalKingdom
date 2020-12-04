//
//  LockScreenViewController.swift
//  AnimalKingdom
//
//  Created by Tom Riddle on 12/3/20.
//

import UIKit

class LockScreenViewController: UIViewController {
    
    var animal: Animal!
    
    var data: Int!
    var timeLimitInSecond : Double = 0.0
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let animal = animal else {
            print("ERROR: NO ANIMAL DATA FOR LOCKSCREEN")
            self.dismiss(animated: true, completion: nil)
            return
        }
        // MARK: animal
        imageView.image = UIImage(named: animal.imageURL)
        nameLabel.text = animal.name
        
        completeButton.isEnabled = true
        // MARK: check if user leave the app
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        //notificationCenter.addObserver(self, selector: #selector(appWillTerminate), name: UIApplication.willTerminateNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appComeToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        // MARK: start timer
        self.timeLimitInSecond = Double(animal.duration)
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
        // MARK: endTime
        endTimeLabel.text = HelperTimer.secondsTo(amount: animal.duration)
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
        // TODO:
        // 1. Stop timer
        HelperTimer.destroyTimer()
        // 2. Update user from server & Add new pet to user list
        UserData.shared().updatePetList(newPet: self.animal)
        // 4. Go back to PetsGidViewController
        self.performSegue(withIdentifier: "addNewAnimalCompleteSegue", sender: self)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        HelperTimer.destroyTimer()
        self.dismiss(animated: true, completion: nil)
    }
    
}
