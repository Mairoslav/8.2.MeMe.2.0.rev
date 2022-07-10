//
//  MemeDetailViewController.swift
//  8.2.MeMe.2.0
//
//  Created by mairo on 02/07/2022.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!
    var memeToEdit: Int?
    var index: Int? // to change an array need its index, index is provided when user selects a meme in the table or collection view. This index should also be passed to the MemeEditor so you can use it when saving the changed meme - see EditMemeViewController. // Udacity
    
    @IBOutlet weak var savedMemeDetail: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true // hide bottom tab bar
        savedMemeDetail.image = meme.memedImage // show detail of saved meme
        
    }
    
    @IBAction func editSavedMeme(_ sender: Any) {
        let editMemeViewController = self.storyboard!.instantiateViewController(withIdentifier: "EditMemeViewController") as! EditMemeViewController
        editMemeViewController.savedMemeForEdit = meme
        // navigationController!.pushViewController(editMemeViewController, animated: true)
        // instead of using above push, use present to avoid displaying table and collection icons in Meme Editor
        
        present(editMemeViewController, animated: true)
        // navigationController?.present(editMemeViewController, animated: true, completion: nil) // also works
        
        // display image so that is covers the whole screen area
        editMemeViewController.imagePickerView.contentMode = .scaleAspectFill
        
        // editMemeViewController.memeIsEditing = true
        editMemeViewController.memeIsModified = true
        // editMemeViewController.setupEditor()
        
    }
    
    /*
     override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
         detailController.meme = self.memes[indexPath.item]
         self.navigationController!.pushViewController(detailController, animated: true)
     } */
     
    
}

