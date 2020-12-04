//
//  PetsGridViewController.swift
//  AnimalKingdom
//
//  Created by loan on 11/27/20.
//

import UIKit
import Parse

class PetsGridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
 
    @IBOutlet weak var sanctuaryLabel: UILabel!
    
    var animals = [UIImage]() //images in the assets folder
    var animal_list : [Animal] = []
    var petUrls : [String] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sanctuaryLabel.font = UIFont(name: "Noteworthy-Bold", size: 48)
        sanctuaryLabel.text = "Sanctuary"
        
        // Do any additional setup after loading the view.
        //collectionView.backgroundView = nil
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 4 //controls the space in between rows
        layout.minimumInteritemSpacing = 4
        
        let width = (view.frame.size.width - layout.minimumInteritemSpacing * 2)/3 //will change depending on phone --> /3 to get 3 images on row. - column spaces
        
        layout.itemSize = CGSize(width: width, height: width * 3 / 2) //x1.5 height to be larger than width
        
        //get a list of animals from Parse
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
                let userPets = UserData.shared().pets
                let animals = AnimalData.shared().animals
                userPets.forEach { (petId) in
                    let myPet = animals.first(where: { (animal) -> Bool in
                        return animal.animalId == petId
                    })
                    if let pet = myPet {
                        self.petUrls.append(pet.imageURL)
                    }
                }
                self.collectionView.reloadData()
            }
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petUrls.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "animalCell", for: indexPath) as! PetCollectionViewCell
        
        cell.animalView.image = UIImage(named: petUrls[indexPath.item])
        
        return cell
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
