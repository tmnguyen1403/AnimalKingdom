//
//  LoadingScreenViewController.swift
//  AnimalKingdom
//
//  Created by Tom Riddle on 12/4/20.
//

import UIKit

class LoadingScreenViewController: UIViewController {

    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var tigerImage: UIImageView!
    @IBOutlet weak var elephantImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogImage.image = nil
        tigerImage.image = nil
        elephantImage.image = nil

        let errorHandler : (Error?) -> Void = { (error) in
            if let error = error {
                print("Error loading animal data \(error)")
            } else {
                print("Unknown error. This is badddd")
            }
           
        }
        
        AnimalData.shared().updateData(errorHandler: errorHandler) {
            print("Get all animals done")

            UserData.shared().updateData(errorHandler: errorHandler) {
                print("Get user done")
                // MARK: get all petUrls
                UserData.shared().addPetUrls(animals: AnimalData.shared().animals)
                let sanctuary = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                self.view.window?.rootViewController = sanctuary
                self.show(sanctuary!, sender: self)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadAnimation()
    }
    
    func loadAnimation() {
        var duration : Double = 0.3
        var currImage = UIImage(named: "dog-baby")
        dogImage?.setImage(currImage, duration: duration) { (isLoaded) in
            if (isLoaded) {
                print("Animated dogImage")
            }
        }
        
        currImage = UIImage(named: "tiger-baby")
        duration += duration - 0.1
        tigerImage?.setImage(currImage, duration: duration, completion: { (isLoaded) in
            if (isLoaded) {
                print("Animated tigerImage")
            } else {
                print("Did not animate")
            }
        })
        
        currImage = UIImage(named: "elephant-baby")
        elephantImage?.setImage(currImage, duration: duration, completion: { (isLoaded) in
            if (isLoaded) {
                print("Animated elephantImage")
            } else {
                print("Did not animate")
            }
        })
    }
}

extension UIImageView {
    func setImage(_ newImage: UIImage?, animated: Bool = true, duration: Double,  completion: ((Bool) -> Void)?) {
        UIView.transition(with: self,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: { self.image = newImage },
                          completion: completion)
    }
}

