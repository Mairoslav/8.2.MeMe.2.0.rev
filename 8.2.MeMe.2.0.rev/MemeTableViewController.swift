//
//  MemeTableViewController.swift
//  8.1.meme.2.0
//
//  Created by mairo on 18/06/2022.
//

import UIKit

// MARK: create a custom table view cell 

class MemeTableViewCell: UITableViewCell {
    @IBOutlet weak var memeTitleLabel: UILabel!
    @IBOutlet weak var memeImageView: UIImageView!
    
}

// MARK: - MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITableViewController (this originally in example)

// MARK: - UITableViewController (only this used here + had to use keyword "override" for func(s) tableView(_ ...))

class MemeTableViewController: UITableViewController {
    
    @IBAction func unwindToMemeTableViewController(segue: UIStoryboardSegue) {}
    
    // for swipe to delete table row
    @IBOutlet var table: UITableView!
    
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
        // for a) swipe to delete table row and b) move cells
        table.delegate = self
        table.dataSource = self
    }
    
    // MARK: reload the table view whenever it appears so memes can be displayed
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        memes = appDelegate.memes // not here if using computed property above - now commented out so that can access memes in func tablevieweditingstyle
        // tableView.contentSize.height = 140
        tableView.reloadData()
    }
    
    // MARK: Table View Data Source
    
    // MARK: 1. tableView(_:numberOfRowsInSection:)
    // to determine the number of rows in Table View based on memes.count
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    // MARK: 2.a tableView(_:cellForRowAt:) integrating custom table view cell
    // to fill our cells with data
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath) as! MemeTableViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        
        // cell.nameLabel.text = meme.topText // + meme.bottomText // add nameLabel under UIImage
    
        cell.memeImageView?.image = meme.memedImage
        cell.memeTitleLabel?.text = meme.topText + " " + meme.bottomText
        tableView.separatorColor = UIColor.black
        
        return cell
    }
    
    // display meme detail
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.item]
        detailController.indexD = indexPath.row // to change an array need its index, see MemeDetailVC
        
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    // swipe to delete table row part-a
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // swipe to delete table row part-b
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            memes.remove(at: indexPath.row) // before we delete other row, we want to delete an item in our model.
            tableView.deleteRows(at: [indexPath], with: .left)
            appDelegate.memes.remove(at: indexPath.row) // to avoid deleted item to re/appear in table/collection. Othwerwise not deleting the meme from the store (the memes array).
        }
        
    }
    
    /*
    // MARK: 2.b tableView(_:cellForRowAt:) alternative with default table view cell
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        
        // cell.nameLabel.text = meme.topText // + meme.bottomText // add nameLabel under UIImage
        // cell.memeImageView?.image = meme.memedImage
        
        cell?.imageView?.image = meme.memedImage
        
        return cell ?? UITableViewCell() // To avoid force unwrap coalesce using '??' to provide a default when the optional value contains 'nil' - would be UITableViewCell()
     
     }
     */
    
    
    /*
    // MARK: tableView(_:heightForRowAt:)
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
        
    }
    */
    
    
    @IBOutlet var sortButton: UIBarButtonItem!
    
    @IBAction func sortButtonTapped(_ sender: Any) {
        
        tableView.isEditing = !tableView.isEditing
        
    }
    
    // method allows the row to be moved to another location in the table view
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // method tells the data source to move a row at specific location in a table view to another location
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let selectedItem = memes[sourceIndexPath.row]
        memes.remove(at: sourceIndexPath.row)
        memes.insert(selectedItem, at: destinationIndexPath.row)
        
        // so that re-order changes are reflected also in collection, apply shared model object memes
        appDelegate.memes.remove(at: sourceIndexPath.row)
        appDelegate.memes.insert(selectedItem, at: destinationIndexPath.row)
        
    }
    
}







