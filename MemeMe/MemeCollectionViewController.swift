//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Jake Malley on 10/08/2016.
//  Copyright © 2016 Jake Malley. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    // Array of memes from the app delegate.
    var memes: [Meme] {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.memes
    }
    
    let reuseIdentifier = "memeCollectionViewCell"
    
    // MARK: Outlets
    @IBOutlet weak var memeCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!

    // MARK: Actions
    @IBAction func addNewMeme(sender: AnyObject) {
        performSegueWithIdentifier("presentMemeEditorViewController", sender: sender)
    }
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure the collection layout.
        configureFlowLayout(self.view.frame.size)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        memeCollectionView.reloadData()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        // Reconfigure the flow layout when the size of the frame changes.
        configureFlowLayout(size)
    }
    
    // MARK: Flow Layout
    func configureFlowLayout(size: CGSize) {
        if let collectionViewFlowLayout = self.collectionViewFlowLayout {
            let flowLayoutSpacing: CGFloat = 3.0
            // As suggested by user: pauls; https://discussions.udacity.com/t/mememe-collectionview-flow-layout/39382/3
            let dimension:CGFloat = size.width >= size.height ? (size.width - (5 * flowLayoutSpacing)) / 4.0 :  (size.width - (2 * flowLayoutSpacing)) / 3.0
        
            collectionViewFlowLayout.minimumInteritemSpacing = flowLayoutSpacing
            collectionViewFlowLayout.minimumLineSpacing = flowLayoutSpacing
            collectionViewFlowLayout.itemSize = CGSizeMake(dimension, dimension)
        }
    }

    // MARK: Collection View Data Source
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
        // Meme object to put into this cell.
        let meme = memes[indexPath.row]
        // Add the image to the cell.
        cell.memeImage.image = meme.memedImaged
        // Return the cell.
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // When an item is selected get the VC, set the meme and push it to the navigation controller.
        let memeDetailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("memeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.meme = memes[indexPath.row]
        navigationController?.pushViewController(memeDetailViewController, animated: true)
    }
}
