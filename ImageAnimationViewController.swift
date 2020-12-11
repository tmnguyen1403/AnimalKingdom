//
//  ImageAnimationViewController.swift
//  AnimalKingdom
//
//  Created by Tom Riddle on 12/9/20.
//

import UIKit

class ImageAnimationViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var oldImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewWillAppear(_ animated: Bool) {
        var duration : Double = 0.75
        let currImage = UIImage(named: "dog-baby")
        imageView.setImage(currImage, duration: duration) { (loaded) in
            if (loaded) {

            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            self.imageView.rotateAnimation()
            self.imageView.scaleXAnimation()
            self.imageView.scaleYAnimation()
            timer.invalidate()
           
        }
        
        Timer.scheduledTimer(withTimeInterval: 3.7, repeats: false) { (timer) in
            let currImage = UIImage(named: "dog-grown")
            self.imageView.setImage(currImage, duration: duration) { (loaded) in
                if (loaded) {

                }
            }
        }
        
    }

    @IBAction func levelUp(_ sender: Any) {
        let newImage = UIImage(named: "dog-grown")
        imageView.setImage(newImage, duration: 0.75, completion: nil)
    }
}
