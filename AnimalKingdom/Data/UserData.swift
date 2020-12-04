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
    let keys = ["objectId", "username", "pets"]

    
    private init() {
        pets = []
        petUrls = []
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
    
    public func addPet() {
        
    }
}
