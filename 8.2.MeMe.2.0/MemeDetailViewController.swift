//
//  MemeDetailViewController.swift
//  8.2.MeMe.2.0
//
//  Created by mairo on 02/07/2022.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!
    
    var index: Int? // to change an array need its index, index is provided when user selects a meme in the table or collection view. This index should also be passed to the MemeEditor so you can use it when saving the changed meme - see indexX in EditMemeViewController. 
    
    @IBOutlet weak var savedMemeDetail: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true // hide bottom tab bar
        savedMemeDetail.image = meme.memedImage // show detail of saved meme
    }
    
    @IBAction func editSavedMeme(_ sender: Any) {
        let editMemeViewController = self.storyboard!.instantiateViewController(withIdentifier: "EditMemeViewController") as! EditMemeViewController
        
        editMemeViewController.savedMemeForEdit = meme // .memedImage
        editMemeViewController.indexX = index // pass the index from MemeDetailViewController to EditMemeViewController so that edited meme does replace itself
        
        // navigationController!.pushViewController(editMemeViewController, animated: true)
        // instead of using above commented out pushViewController..., use present to avoid displaying table and collection icons in Meme Editor ->
        
        navigationController?.present(editMemeViewController, animated: true, completion: nil)
        // alternativelly below code also works
        // present(editMemeViewController, animated: true)
        
        // display image so that is covers the whole screen area
        editMemeViewController.imagePickerView.contentMode = .scaleAspectFill
        
        // done button to show only when already saved memeIsModified = true
        editMemeViewController.memeIsModified = true
        
    }
    
}

