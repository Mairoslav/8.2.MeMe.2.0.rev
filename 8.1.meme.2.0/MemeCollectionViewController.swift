//
//  MemeCollectionViewController.swift
//  8.1.meme.2.0
//
//  Created by mairo on 28/05/2022.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController { // new
    
    // MARK: to access memes from the CollectionVC or the TableVC
    // In the Sent Memes Table and Collection View Controllers create a property called memes, and set it to the memes array from the AppDelegate.
    
    var memes: [AnyObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    memes = appDelegate.memes
    
    // Alternately, a computed property can achieve the same result.
    /*
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    */
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

