//
//  Animal.swift
//  AnimalKingdom
//
//  Created by Tom Riddle on 12/1/20.
//

import Foundation

class Animal : Codable {
    var name : String
    var level : Int
    var imageURL : String
    var duration : Int
    
    init(name : String, level: Int, imageURL: String, duration : Int) {
        self.name = name
        self.level = level
        self.imageURL = imageURL
        self.duration = duration
    }
    
    convenience init?(data : [String : Any]) {
        guard let name = data["name"] as? String,
              let level = data["level"] as? Int,
              let imageURL = data["imageURL"] as? String,
              let duration = data["duration"] as? Int else {
            print("Cannot parse data for this animal")
            return nil
        }
        self.init(name: name, level: level, imageURL: imageURL, duration: duration)
    }
}
