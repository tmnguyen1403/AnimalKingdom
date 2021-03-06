//
//  AnimalData.swift
//  AnimalKingdom
//
//  Created by Tom Riddle on 12/1/20.
//

import Foundation
import Parse

class AnimalData {
    
    // MARK: - Properties
    private static let sharedAnimalData = AnimalData()
    public private(set) var animals : [Animal]
    public let maxLevel: Int = 2
    let keys = ["objectId", "name", "level", "imageURL", "duration", "animalId", "nickname"]

    
    private init() {
        animals = []
    }
    class func shared() -> AnimalData {
        return sharedAnimalData
    }
    
    public func updateData(errorHandler: @escaping (Error?) -> (),completionHandler: @escaping () -> ()) {
        if (self.animals.count == 0) {
            print("Get animals from server")
            let query = PFQuery(className:"Animal")
           
            query.findObjectsInBackground { (animals, error) in
                print("callback of findObjectsInBackground")
                if error == nil && animals != nil {
                    for data in animals! {
                        if let animal = Animal(data: data.dictionaryWithValues(forKeys: self.keys)) {
                            self.animals.append(animal)
                        }
                    }
                    print("I have \(self.animals.count) animals")
                    completionHandler()
                } else {
                    print(error ?? "Unknown error")
                    errorHandler(error)
                }
            }
        } else {
            print("No need to get animals from server")
            completionHandler()
        }
    }
}
