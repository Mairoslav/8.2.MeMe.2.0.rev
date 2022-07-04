//
//  MemeDetailViewController.swift
//  8.2.MeMe.2.0
//
//  Created by mairo on 02/07/2022.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!
    
    @IBOutlet weak var savedMemeDetail: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true // hide bottom tab bar
        savedMemeDetail.image = meme.memedImage // show detail of saved meme
    }
    
    @IBAction func editSavedMeme(_ sender: Any) {
        let editMemeViewController = self.storyboard!.instantiateViewController(withIdentifier: "EditMemeViewController") as! EditMemeViewController
        editMemeViewController.savedMemeForEdit = meme
        navigationController!.pushViewController(editMemeViewController, animated: true) // original
    }
    
    /*
     override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
         detailController.meme = self.memes[indexPath.item]
         self.navigationController!.pushViewController(detailController, animated: true)
     } */
     
    
}

