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
    var levelingAnimal: Int = -1
    // MARK: layout prepare
    let columns: CGFloat = 3.0
    let inset: CGFloat = 8.0
    let spacing: CGFloat = 8.0
    var userAlert: UIAlertController!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hi I am viewDidLoad")

        // Do any additional setup after loading the view.
        //collectionView.backgroundView = nil
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Hi I am viewWillAppear")
        //MARK: Loading animation
        //We have to manually add every single item of our data in a certain interval for the animation to work
        let userData = UserData.shared()
        var indexCounter = 0
        
        //MARK: When adding new animal from LockScreenViewController, only animate the new cell
        if (userData.hasNewPet) {
            self.petUrls = userData.petUrls
            self.petUrls.removeLast()
            print("controller petUrls vs userData petUrls: \(self.petUrls.count) : \(userData.petUrls.count)")
            indexCounter = self.petUrls.count
            userData.resetHasNewPet()
        }
        else if (self.levelingAnimal != -1) {
            let index = self.levelingAnimal
            print("I got leveledup")
            self.petUrls[index] = userData.petUrls[index]
            //MARK: perform special animation for this
            self.collectionView?.reloadData()
            //self.collectionView?.deleteItems(at: [IndexPath(item: index, section: 0)])
            //self.collectionView?.insertItems(at: [IndexPath(item: index - 1, section: 0)])
            self.levelingAnimal = -1
        }
        
        //MARK: start animation
        if (userData.petUrls.count > self.petUrls.count) {
            Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (timer) in
                self.petUrls.append(userData.petUrls[indexCounter])
                self.collectionView?.insertItems(at: [IndexPath(item: indexCounter, section: 0)])
                self.collectionView?.scrollToItem(at: IndexPath(item: indexCounter, section: 0), at: .bottom, animated: true)
                print("call timer \(indexCounter)")
                indexCounter += 1
                if (indexCounter == userData.petUrls.count) {
                    timer.invalidate()
                }
            }
        }
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
            let tapRecognizer = AddAnimalRecognizer(target: self, action: #selector(levelUpPressed))
            tapRecognizer.animal = animal
            tapRecognizer.petIndex = indexPath.item
            cell.addGestureRecognizer(tapRecognizer)
        }
        
        return cell
     }
    
    @objc func levelUpPressed(_ sender: AddAnimalRecognizer) {
        let maxLevel: Int = 2

        guard let animal = sender.animal else {
            print("No target animal")
            return
        }
        if (animal.level < AnimalData.shared().maxLevel) {
            self.userAlert = UIAlertController(title: "❤️Level 1❤️", message: "Do you want to level up this pet?", preferredStyle: .alert)
            
            self.userAlert.addAction(UIAlertAction(title: "Yes", style: .default){ (action) in
                self.userAlert = nil
                self.levelUp(mypet: animal, sender)
            })
    //
            self.userAlert.addAction(UIAlertAction(title: "No", style: .cancel){ (action) in
                self.dismiss(animated: true, completion: nil)
                self.userAlert = nil
            })
        } else {
            self.userAlert = UIAlertController(title: "🔥Max Level🔥", message: "🐶Your pet has reached the maximum level!🐶", preferredStyle: .alert)
            self.userAlert.addAction(UIAlertAction(title: "Ok", style: .cancel){ (action) in
                self.dismiss(animated: true, completion: nil)
                self.userAlert = nil
            })
        }
        
        self.present(self.userAlert, animated: true, completion: nil)
    }
    
    func levelUp(mypet animal: Animal, _ sender: AddAnimalRecognizer) {
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
            controller.delegate = self
            self.levelingAnimal = sender.petIndex // MARK: use this to perform animation after completing level up
            self.present(controller, animated: true, completion: nil)
        } else {
            print("Cannot find animal to level up")
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

extension PetsGridViewController: LockScreenDelegate {
    func onCompleteIncubation() {
        self.dismiss(animated: true, completion: {
            print("dismiss oldview")
        })
    }
    
    func onCancelIncubation() {
        self.dismiss(animated: true, completion: {
            print("PetsGridViewController onCancelIncubation dismissed")
        })
    }
}
