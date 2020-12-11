//
//  AnimationHelper.swift
//  AnimalKingdom
//
//  Created by Tom Riddle on 12/11/20.
//

import Foundation
import UIKit


extension UIImageView {
    func setImage(_ newImage: UIImage?, animated: Bool = true, duration: Double,  completion: ((Bool) -> Void)?) {
        UIView.transition(with: self,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: { self.image = newImage },
                          completion: completion)
    }
}

extension UIView {
    //MARK : reference https://stackoverflow.com/questions/31478630/animate-rotation-uiimageview-in-swift
    func rotateAnimation() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.isCumulative = true
        rotation.duration = 1
        rotation.repeatCount = 3
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func scaleXAnimation() {
        let zoom : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale.x")
        zoom.fromValue = 1
        zoom.toValue = 2
        zoom.duration = 1
        zoom.repeatCount = 3
        self.layer.add(zoom, forKey: "scaleXAnimation")
    }
    
    func scaleYAnimation() {
        let zoom : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale.y")
        zoom.fromValue = 1
        zoom.toValue = 2
        zoom.duration = 1
        zoom.repeatCount = 3
        self.layer.add(zoom, forKey: "scaleYAnimation")
    }
}
