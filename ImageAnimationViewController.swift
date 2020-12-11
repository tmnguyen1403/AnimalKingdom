//
//  ImageAnimationViewController.swift
//  AnimalKingdom
//
//  Created by Tom Riddle on 12/9/20.
//

import UIKit

protocol ImageAnimationDelegate: class {
    func onAnimationCompete()
}

class ImageAnimationViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var oldImage: UIImage!
    var newImage: UIImage!
    weak var delegate: ImageAnimationDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let duration : Double = 0.4
        imageView.setImage(self.oldImage, duration: duration) { (loaded) in
            if (loaded) {

            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            //MARK: This animation will take 3.0 seconds
            self.imageView.rotateAnimation()
            self.imageView.scaleXAnimation()
            self.imageView.scaleYAnimation()
            timer.invalidate()
           
        }
        
        Timer.scheduledTimer(withTimeInterval: 3.7, repeats: false) { (timer) in
            self.imageView.setImage(self.newImage, duration: duration) { (loaded) in
                if (loaded) {
                    print("Animation completed")
                    self.delegate?.onAnimationCompete()
                }
            }
        }
        
    }

    @IBAction func levelUp(_ sender: Any) {
        let newImage = UIImage(named: "dog-grown")
        imageView.setImage(newImage, duration: 0.75, completion: nil)
    }
}
