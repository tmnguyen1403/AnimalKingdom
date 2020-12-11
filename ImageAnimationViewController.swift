//
//  ImageAnimationViewController.swift
//  AnimalKingdom
//
//  Created by Tom Riddle on 12/9/20.
//

import UIKit

class ImageAnimationViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    var oldImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var duration : Double = 0.75
        let currImage = UIImage(named: "dog-baby")
        imageView.setImage(currImage, duration: duration) { (loaded) in
            if (loaded) {
               
            }
        }
        let newImage = UIImage(named: "frog-baby")
        duration += duration * 2
        self.imageView2.setImage(newImage, duration: duration, completion: { (isLoaded) in
            if (isLoaded) {
                print("Animated imageView2")
            } else {
                print("Did not animate")
            }
        })
    }

    @IBAction func levelUp(_ sender: Any) {
        let newImage = UIImage(named: "dog-grown")
        imageView.setImage(newImage, duration: 0.75, completion: nil)
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
