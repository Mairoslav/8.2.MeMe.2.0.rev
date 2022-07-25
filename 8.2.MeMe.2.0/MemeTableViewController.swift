//
//  MemeTableViewController.swift
//  8.1.meme.2.0
//
//  Created by mairo on 18/06/2022.
//

import UIKit // whole file MemeTableViewController.swift new 2.0

// MARK: create a custom table view cell 

class MemeTableViewCell: UITableViewCell {
    @IBOutlet weak var memeTitleLabel: UILabel!
    @IBOutlet weak var memeImageView: UIImageView!
    
}

// MARK: - MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITableViewController (this originally in example)

// MARK: - UITableViewController (only this used here + had to use keyword "override" for func(s) tableView(_ ...))

class MemeTableViewController: UITableViewController {
    
    @IBOutlet var table: UITableView! // swipe to delete table row
    
    /*
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    } // vs. MemeCollectionViewController here alternative - a computed property to achieve the same result - to access the array stored in the App Delegate to populate both the collection and the table view controllers
    */
    
    var memes: [Meme] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
     
    // MARK: viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self // swipe to delete table row
        table.dataSource = self // swipe to delete table row
        // reloadTableAndCollection() // notification
    }
    
    // MARK: reload the table view whenever it appears so memes can be displayed
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        memes = appDelegate.memes // not here if using computed property above - now commented out so that can access memes in func tablevieweditingstyle
        // tableView.contentSize.height = 140
        tableView.reloadData() // new 2.0
    }
    
    // MARK: Table View Data Source
    
        // MARK: 1. tableView(_:numberOfRowsInSection:)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    } // numberOfRows
    
        // MARK: 2.a tableView(_:cellForRowAt:) integrating custom table view cell
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath) as! MemeTableViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Change color of table view cell when clicked
        // ...
    
        // Set the name and image
        
        // cell.nameLabel.text = meme.topText // + meme.bottomText // add nameLabel under UIImage
    
        cell.memeImageView?.image = meme.memedImage
        cell.memeTitleLabel?.text = meme.topText + " " + meme.bottomText
        
        return cell
    } // cellForRowAtIndexPath
    
    // display meme detail
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.item]
        detailController.index = indexPath.row // to change an array need its index, see MemeDetailVC
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    // swipe to delete table row part-a
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // swipe to delete table row part-b
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // tableView.beginUpdates()
            memes.remove(at: indexPath.row) // before we delete ther row, we want to delete an item in our model.
            tableView.deleteRows(at: [indexPath], with: .left)
            // tableView.reloadData() // ??? deleted rows keep re-appearing after new meme is shared
            // tableView.endUpdates()
            
            NotificationCenter.default.post(name: Notification.Name("reloadAfterRowDeleted"), object: nil)
            tableView.reloadData()
        }
        
    }
    
   
     
    /*  // MARK: 2.b tableView(_:cellForRowAt:) alternative with default table view cell
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        
        // cell.nameLabel.text = meme.topText // + meme.bottomText // add nameLabel under UIImage
        // cell.memeImageView?.image = meme.memedImage
        
        cell?.imageView?.image = meme.memedImage
        
        return cell ?? UITableViewCell() // To avoid force unwrap coalesce using '??' to provide a default when the optional value contains 'nil' - would be UITableViewCell()
     
     } */
    
    
    /*  // MARK: tableView(_:heightForRowAt:)
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
        
    } */
    
}







