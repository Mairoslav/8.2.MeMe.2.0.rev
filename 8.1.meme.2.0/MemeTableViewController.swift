//
//  MemeTableViewController.swift
//  8.1.meme.2.0
//
//  Created by mairo on 18/06/2022.
//

import UIKit

// MARK: - ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.memes.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        
        // cell.nameLabel.text = meme.topText // + meme.bottomText // add nameLabel under UIImage
        // cell.memeImageView?.image = meme.memedImage
        
        cell?.imageView?.image = meme.memedImage
        
        return cell! // How to coalesce using '??' to provide a default when the optional value contains 'nil' in this case? To avoid force unwrap.
        
    }
    
}
