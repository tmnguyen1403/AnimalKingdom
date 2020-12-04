//
//  LockScreenViewController.swift
//  AnimalKingdom
//
//  Created by Tom Riddle on 12/3/20.
//

import UIKit

class LockScreenViewController: UIViewController {
    
    var animal: Animal!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let animal = animal {
            print("This is \(animal.imageURL)")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
