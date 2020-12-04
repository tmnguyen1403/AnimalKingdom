//
//  User.swift
//  AnimalKingdom
//
//  Created by Tom Riddle on 12/3/20.
//

import Foundation

class User : Codable, Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self).hashValue)
    }
    
    var objectId: String
    var username : String
    var pets : [String]
    
    init(objectId: String, userName : String, pets: [String]) {
        self.objectId = objectId
        self.username = userName
        self.pets = pets
    }
    
    convenience init?(data : [String : Any]) {
        guard let objectId = data["objectId"] as? String,
              let userName = data["username"] as? String,
              let pets = data["pets"] as? [String] else {
            print("Cannot parse data for this user")
            return nil
        }
        self.init(objectId: objectId, userName: userName, pets: pets)
    }
}
