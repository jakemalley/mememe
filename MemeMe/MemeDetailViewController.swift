//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Jake Malley on 10/08/2016.
//  Copyright © 2016 Jake Malley. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    // Meme to be displayed.
    var meme: Meme!
    
    // MARK: Outlets
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var createdOnLabel: UILabel!
    
    // MARK: Overrides
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the tab bar controller.
        self.tabBarController?.tabBar.hidden = true
        
        // Set the memed Kmage.
        memeImage.contentMode = UIViewContentMode.ScaleAspectFit
        memeImage.image = meme.memedImaged
        
        // Set the created on text.
        createdOnLabel.text = "Created: \(meme.getDateCreatedInFormat("dd/MM/yyyy HH:mm"))"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unhide the tab bar controller.
        self.tabBarController?.tabBar.hidden = false
    }

}
