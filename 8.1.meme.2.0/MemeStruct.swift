//
//  MemeStruct.swift
//  4.0meMeV1.0
//
//  Created by mairo on 25/03/2022.
//

import Foundation
import UIKit // have to import UIKit, otherwise Error: "Cannot find type 'UIImage' in scope"

// MARK: struct
// Meme struct is in a separate file. In the MVC design pattern, we want to keep the model and controller code separately.
// for each individual meme object need struct that includes the following component properties:

struct Meme {
    var topText: String = ""
    var bottomText: String = ""
    var image: UIImage?
    var memedImage: UIImage?
}
