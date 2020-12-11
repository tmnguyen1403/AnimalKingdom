//
//  LockScreenViewController.swift
//  AnimalKingdom
//
//  Created by Tom Riddle on 12/3/20.
//

import UIKit

protocol LockScreenDelegate: class {
    func onCompleteIncubation()
    func onCancelIncubation()
}

class LockScreenViewController: UIViewController {
    
    var animal: Animal!
    var data: Int!
    var timeLimitInSecond : Double = 0.0
    
    //MARK: Data for level up
    var isLevelUp: Bool = false
    var petIndex: Int = -1
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    var userAlert : UIAlertController!
    var isLockButtonPressed: Bool = false
    
    //MARK: delegate
    weak var delegate: LockScreenDelegate!
    
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
        // MARK: observer when scene enter background
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(sceneWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        //notificationCenter.addObserver(self, selector: #selector(appWillTerminate), name: UIApplication.willTerminateNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appComeToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        //will not notify when swiping down,
        notificationCenter.addObserver(self, selector: #selector(cancelIncubation), name: UIScene.didEnterBackgroundNotification, object: nil)
        //only notify when pressing lock screen button,
        notificationCenter.addObserver(self, selector: #selector(lostProtectedData), name:  UIApplication.protectedDataWillBecomeUnavailableNotification, object: nil)
        
        // MARK: start timer
        self.timeLimitInSecond = Double(animal.duration)
        HelperTimer.setStartTime()
        setupTimerForClock()
        // MARK: endTime
        endTimeLabel.text = HelperTimer.secondsTo(amount: animal.duration)
    }
    
    func setupTimerForClock() {
        HelperTimer.createStartTimer{
            self.startTimeLabel.text = HelperTimer.updateTimer()
            if HelperTimer.didWaitTimePass(second: self.timeLimitInSecond) {
                print("You animal is hatched")
                //update UI
                self.completeButton.isEnabled = true
                HelperTimer.destroyTimer()
            }
        }
    }
    
    // MARK: Cases' handler when user leaving the app
    
    // MARK: called when receive protectedDataWillBecomeUnavailableNotification
    @objc func lostProtectedData() {
        print("lostProtectedData called")
        setupTimerForClock()
        self.userAlert?.dismiss(animated: true, completion: {
            self.userAlert = nil
        })
        self.isLockButtonPressed = true
    }

    // MARK: called when receive didEnterBackgroundNotification
    @objc func cancelIncubation() {
        print("cancelIncubation did Enterbackground")
        HelperTimer.destroyTimer()
        self.startTimeLabel.text = "00:00:00"
        self.userAlert?.dismiss(animated: true, completion: {
            self.userAlert = nil
        })
    }
    
    
    
    @objc func sceneWillResignActive() {
        print("sceneWillResignActive")
        self.userAlert = UIAlertController(title: "🐶WARNING🐱", message: "Leaving the app will cancel your current incubation", preferredStyle: .alert)
        self.userAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(self.userAlert, animated: true, completion: nil)
    }
    
    @objc func appComeToForeground() {
        print("App come to foreground")
        if (self.isLockButtonPressed) {
            self.isLockButtonPressed = false
            return
        }
        
        self.userAlert = UIAlertController(title: "🙊Oh No! Your incubation has failed🙈", message: "Do you want to start over?", preferredStyle: .alert)
        

        self.userAlert.addAction(UIAlertAction(title: "Yes", style: .default){ (action) in
            HelperTimer.setStartTime()
            self.setupTimerForClock()
        })
//
        self.userAlert.addAction(UIAlertAction(title: "No", style: .cancel){ (action) in
            self.dismiss(animated: true, completion: nil)
        })
        
        self.present(self.userAlert, animated: true, completion: nil)
    }
    
    @IBAction func onComplete(_ sender: Any) {
        print("onComplete - add the new animal to user achievements")
        // MARK: DEMO
        // TODO:
        // 1. Stop timer
        HelperTimer.destroyTimer()
        // 2. Update user from server & Add new pet to user list
        if (self.isLevelUp) {
            UserData.shared().replacePet(at: self.petIndex, with: self.animal)
        } else {
            UserData.shared().updatePetList(newPet: self.animal)
        }
        // 4. Go back to PetsGidViewController
        delegate?.onCompleteIncubation()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        HelperTimer.destroyTimer()
        delegate?.onCancelIncubation()
    }
}
