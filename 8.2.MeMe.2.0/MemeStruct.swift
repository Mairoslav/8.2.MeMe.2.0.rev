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
    
    // MARK: properties
    
    var topText: String = ""
    var bottomText: String = ""
    var image: UIImage?
    var memedImage: UIImage?
    
    /*
    var topText: String! = nil // with init
    var bottomText: String! = nil
    var image: UIImage! = nil
    var memedImage: UIImage! = nil
    
    static var array: [Meme] = [Meme]()

    init() {
        topText = nil
        bottomText = nil
        image = nil
        memedImage = nil
    }
    
    init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    } */
}
