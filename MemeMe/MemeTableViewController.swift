//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Jake Malley on 10/08/2016.
//  Copyright © 2016 Jake Malley. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Array of memes from the app delegate.
    var memes: [Meme] {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.memes
    }
    
    // Reuse identifier for the table view cells.
    let reuseIdentifier = "memeTableViewCell"
    
    // MARK: Outlets
    @IBOutlet weak var memeTableView: UITableView!
    @IBOutlet weak var editMemeTableButton: UIBarButtonItem!

    // MARK: Actions
    @IBAction func addNewMeme(sender: AnyObject) {
        performSegueWithIdentifier("presentMemeEditorViewController", sender: sender)
    }
    
    @IBAction func editMemeTable(sender: AnyObject) {
        // Flip the current editing mode.
        memeTableView.editing = !memeTableView.editing
        // Update the top-left button's text appropriately.
        editMemeTableButton.title = memeTableView.editing ? "Done" : "Edit"
    }
    
    // MARK: Overrides
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        memeTableView.reloadData()
    }
    
    // MARK: Table View Data Source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Dequeue a cell with the appropriate reuse identifier
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)!
        // Meme object that should be put in this cell.
        let meme = memes[indexPath.row]
        
        // Set the text label of this cell to the top text.
        cell.textLabel?.text = "\(meme.topText)...\(meme.bottomText)"
        cell.imageView?.image = meme.memedImaged
        
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = "Created: \(meme.getDateCreatedInFormat("dd/MM/yyyy HH:mm"))"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // When a row is selected get the VC, set the meme and push it to the navigation controller.
        let memeDetailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("memeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.meme = memes[indexPath.row]
        navigationController?.pushViewController(memeDetailViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // Delete meme from array.
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            // Delete from the table view.
            memeTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }

}
