//
//  MemeCollectionViewController.swift
//  8.1.meme.2.0
//
//  Created by mairo on 28/05/2022.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController { // new 2.0
    
    // MARK: UICollectionViewFlowLayout setUp
    // @IBOutlet weak var flowLayout: UICollectionViewFlowLayout! // check if needed
    
    // MARK: to access memes from the CollectionVC or the TableVC
    // In the Sent Memes Table and Collection View Controllers create a property called memes, and "set it to the memes array from the AppDelegate" ~ see meme = appDelegate.memes in func viewDidLoad().
    
    var memes: [Meme] = [] // need to change the array from [AnyObject] to [Meme]
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    // memes = appDelegate.memes // cannot set properties in the class scope, you need to do it inside a method or a closure. You can only do that for computed properties. To fix the issue you need to set memes in viewWillAppear()
    
    // Alternately, a computed property can achieve the same result.
    /*
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // new 2.0 collectionConstraints
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 118, height: 118)
        collectionView.collectionViewLayout = layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        memes = appDelegate.memes // new 2.0 "set it to the memes array from the AppDelegate"
        collectionView!.reloadData() // new 2.0
    }
    
    // MARK: Collection View Data Source
    
        // MARK: 1. collectionView(_:numberOfItemsInSection:)
        // memes will be stored in meme's array, this method returns the number of memes in that array
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    } // new 2.0
    
    // MARK: 2. collectionView(_:cellForItemAt:)
    // (The default UICollectionViewCell leaves no crativity space in terms of meme display), so this method return custom "cool" custom cell UICollectionViewCell > better write custom cell via CocoaTouchClass an have it inherit from "dry" cell > now can make "dry" cell "cool" giving her properties to display a meme e.g. two Labels & an Image...
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        
        // cell.nameLabel.text = meme.topText // + meme.bottomText // add nameLabel under UIImage
        cell.memeImageView?.image = meme.memedImage // UIImage(named: meme.memedImage)
        
        return cell
    }
    
    // MARK: display meme detail
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.item]
        detailController.index = indexPath.row // to change an array need its index, see MemeDetailVC
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    
    
    
    /*
    @IBAction func selectAllA(_ sender: Any) { 
            memes.removeAll()
            memes.removeAll()

            for (index, element) in self.memes.enumerated() { // append only item of array, so adjust for (index, element), no dictionary, but array...
                memes.append(Meme(item: index, section: 0)) // append only item of array
                memes.append(element)
            }

            collectionView.reloadData()
            print(memes)
        }
    */
}


