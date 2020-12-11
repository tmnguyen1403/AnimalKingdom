//
//  Animal.swift
//  AnimalKingdom
//
//  Created by Tom Riddle on 12/1/20.
//

import Foundation

class Animal : Codable, Hashable {
    static func == (lhs: Animal, rhs: Animal) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self).hashValue)
    }
    
    var objectId: String
    var animalId: String
    var name : String
    var level : Int
    var imageURL : String
    var duration : Int
    var nickname: String
    
    init(objectId: String, animalId: String, name : String, level: Int, imageURL: String, duration : Int, nickname: String) {
        self.objectId = objectId
        self.animalId = animalId
        self.name = name
        self.level = level
        self.imageURL = imageURL
        self.duration = duration
        self.nickname = nickname
    }
    
    convenience init?(data : [String : Any]) {
        guard let objectId = data["objectId"] as? String,
              let animalId = data["animalId"] as? String,
              let name = data["name"] as? String,
              let level = data["level"] as? Int,
              let imageURL = data["imageURL"] as? String,
              let duration = data["duration"] as? Int else {
            print("Cannot parse data for this animal")
            return nil
        }
        var nickname = data["nickname"] as? String
        if nickname == nil {
            nickname = "Unknown"
        }
        self.init(objectId: objectId, animalId: animalId, name: name, level: level, imageURL: imageURL, duration: duration, nickname: nickname!)
    }
}
