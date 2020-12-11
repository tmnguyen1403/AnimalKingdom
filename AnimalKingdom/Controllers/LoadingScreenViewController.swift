//
//  LoadingScreenViewController.swift
//  AnimalKingdom
//
//  Created by Tom Riddle on 12/4/20.
//

import UIKit

class LoadingScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
    

}
