//
//  MemeCollectionViewController.swift
//  8.1.meme.2.0
//
//  Created by mairo on 28/05/2022.
//

import UIKit

// Redundant conformance of 'MemeCollectionViewController' to protocol 'UICollectionViewDataSource', 'UICollectionViewDelegate'
// only UICollectionViewDelegateFlowLayout added vs previous base
class MemeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
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
    
    // private var collectionView: UICollectionView? // why no declaration needed?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set Collection Constraints
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 118, height: 118)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        // for drag&drop
        collectionView.collectionViewLayout = layout
        collectionView?.delegate = self
        collectionView?.dataSource = self
        view.addSubview(collectionView ?? UICollectionView())
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        collectionView?.addGestureRecognizer(gesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        memes = appDelegate.memes // set it to the memes array from the AppDelegate
        collectionView!.reloadData()
    }
    
    // MARK: Collection View Data Source
    
    // MARK: 1. collectionView(_:numberOfItemsInSection:)
    // memes will be stored in meme's array, this method returns the number of memes in that array
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    // MARK: 2. collectionView(_:cellForItemAt:)
    // The default UICollectionViewCell leaves no space in terms of more meme display options, so this method return custom cell UICollectionViewCell > better write custom cell via CocoaTouchClass an have it inherit from default cell > now can make customize default cell, giving her properties to display a meme e.g. two Labels & an Image...
    
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
    
    // MARK: drag&drop
    
    // MARK: long press gesture recognizer
    
    // for drag&drop
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        // unwrap collection view
        guard let collectionView = collectionView else {
            return
        }
        
        // MARK: switch over the states (.began, .changed, .ended) on the gesture, and handle interactive movements accordingly
        
        // for drag&drop, to react based on gesture location
        switch gesture.state {
        case .began:
            // here we want to get the index path of collection where first touched
            guard let targetIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                return // if we are not able to get an index path we are going to return, if user pressing out of area...
            }
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
        
    }
    
    // subview layout bounds
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    // return CGSize as defined for layout in viewDidLoad()
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 118, height: 118)
    }
    
    // MARK: two re-order methods
    
    // telling collection view that given item at indexPath position can move
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // telling where to shift data model
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // to swap the positions in the array
        let item = memes.remove(at: sourceIndexPath.row)
        memes.insert(item, at: destinationIndexPath.row)
        
        // so that re-order changes are reflected also in table
        appDelegate.memes.remove(at: sourceIndexPath.row)
        appDelegate.memes.insert(item, at: destinationIndexPath.row)
    }
    
}


