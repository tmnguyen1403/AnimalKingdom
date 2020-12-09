//
//  PetCollectionViewCell.swift
//  AnimalKingdom
//
//  Created by loan on 11/27/20.
//

import UIKit

enum LevelImage: String {
    case level1 = "Level1"
    case level2 = "Level2"
}

class PetCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var animalView: UIImageView!
    @IBOutlet weak var animalNameLabel: UILabel!
    weak var animal : Animal!
    @IBOutlet weak var levelImageView: UIImageView!
    
    func setLevelImageView() {
        if let animal = animal {
            var imageName = LevelImage.level1.rawValue
            if animal.level == 2 {
                imageName = LevelImage.level2.rawValue
            }
            levelImageView.image = UIImage(named: imageName)
        }
    }
}
