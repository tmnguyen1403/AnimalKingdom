//
//  AddAnimalRecognizer.swift
//  AnimalKingdom
//
//  Created by Tom Riddle on 12/3/20.
//

import UIKit

class AddAnimalRecognizer: UITapGestureRecognizer {
    var objectId : String!
    weak var animal: Animal!
    var petIndex: Int = -1
}

