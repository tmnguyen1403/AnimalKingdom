//
//  UserData.swift
//  AnimalKingdom
//
//  Created by Tom Riddle on 12/3/20.
//

import Foundation
import Parse

class UserData {
    
    // MARK: - Properties
    private static let sharedUserData = UserData()
    public private(set) var pets : [String]
    public private(set) var petUrls : [String]
    public private(set) var hasNewPet : Bool
    let keys = ["objectId", "username", "pets"]

    
    private init() {
        pets = []
        petUrls = []
        hasNewPet = false
    }
    
    class func shared() -> UserData {
        return sharedUserData
    }
    
    public func updateData(errorHandler: @escaping (Error?) -> (),completionHandler: @escaping () -> ()) {
        if (self.pets.count == 0) {
            // MARK: test user
            let username = "tomtester"
            let password = "HelloWorld123"
            PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
                if let myUser = user{
                    print("Login successfully for \(username)")
                    guard let localUser =  User(data: myUser.dictionaryWithValues(forKeys: self.keys)) else {
                        print("Cannot parse data for \(username)")
                        errorHandler(error)
                        return
                    }
                    self.pets = localUser.pets
                    print("I have \(self.pets.count) animals")
                    completionHandler()
                } else {
                    print("Cannot login data for \(username) \(String(describing: error?.localizedDescription))")
                    errorHandler(error)
                }
            }
        }
    }
    
    public func replacePet(at index: Int, with pet: Animal) {
        if (index >= 0  && index < self.pets.count) {
            self.pets[index] = pet.animalId
            self.petUrls[index] = pet.imageURL
            self.updatePetListToServer()
        } else {
            print("Invalid index")
        }
    }
    
    public func addPetUrls(animals: [Animal]) {
        self.pets.forEach { (petId) in
            let myPet = animals.first(where: { (animal) -> Bool in
                return animal.animalId == petId
            })
            if let pet = myPet {
                self.petUrls.append(pet.imageURL)
            }
        }
    }
    
    public func updatePetList(newPet: Animal) {
        self.pets.append(newPet.animalId)
        self.petUrls.append(newPet.imageURL)
        self.hasNewPet = true
        self.updatePetListToServer()
    }
    
    public func resetHasNewPet() {
        self.hasNewPet = false
    }
    // MARK: Always run this after updatePetList
    public func updatePetListToServer() {
        //UPDATE TO SERVER
        if let user = PFUser.current() {
            user["pets"] = self.pets
            user.saveInBackground { (status, error) in
                print("UPDATTE PET FOR user \(status)")
                if let error = error {
                    print("ERROR UPDATING PET FOR user \(error.localizedDescription)")
                }
            }
        }
    }
}
