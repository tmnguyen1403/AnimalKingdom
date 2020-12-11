//
//  PetsGridViewController.swift
//  AnimalKingdom
//
//  Created by loan on 11/27/20.
//

import UIKit
import Parse

class PetsGridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
 
    
    var animals = [UIImage]() //images in the assets folder
    var animal_list : [Animal] = []
    var petUrls : [String] = []
    
    // MARK: layout prepare
    let columns: CGFloat = 3.0
    let inset: CGFloat = 8.0
    let spacing: CGFloat = 8.0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //collectionView.backgroundView = nil
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        petUrls = UserData.shared().petUrls
        collectionView.reloadData()
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petUrls.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "animalCell", for: indexPath) as! PetCollectionViewCell
        
        cell.animalView.image = UIImage(named: petUrls[indexPath.item])
        cell.animalNameLabel.text = "Uknown Specie"
        
        // MARK: get animal name
        if let animal = AnimalData.shared().animals.first(where: { (animal) -> Bool in
            return animal.imageURL == petUrls[indexPath.item]
        }) {
            cell.animal = animal
            cell.animalNameLabel.text = animal.name
            //cell.animalNameLabel.sizeToFit()
            cell.setLevelImageView()
            // MARK: interaction when click on cell
            let tapRecognizer = AddAnimalRecognizer(target: self, action: #selector(levelUp))
            tapRecognizer.animal = animal
            tapRecognizer.petIndex = indexPath.item
            cell.addGestureRecognizer(tapRecognizer)
        }
        
        return cell
     }
    
    @objc func levelUp(_ sender: AddAnimalRecognizer) {
        let maxLevel: Int = 2
        if let animal = sender.animal {
            if (animal.level < maxLevel) {
                print("I will level up your animal")
                //MARK: Find the corresponding level up animal
                let animalId = "\(animal.name)-\(animal.level+1)"
                if let higherAnimal = AnimalData.shared().animals.first(where: { (myAnimal) -> Bool in
                    return myAnimal.animalId == animalId
                }){
                    //MARK: Go to LockScreenViewController
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(identifier: "lockscreenViewController") as! LockScreenViewController
                    
                    controller.animal = higherAnimal
                    controller.isLevelUp = true
                    controller.petIndex = sender.petIndex
                    self.present(controller, animated: true, completion: nil)
                } else {
                    print("Cannot find animal to level up")
                }
               
               
            } else {
                print("Your animal is at max level")
                return
            }
        }
    }
}

extension PetsGridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int((collectionView.frame.width / columns) - (inset + spacing))
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
}
