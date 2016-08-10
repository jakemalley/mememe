//
//  Meme.swift
//  MemeMe
//
//  Created by Jake Malley on 08/08/2016.
//  Copyright © 2016 Jake Malley. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImaged: UIImage
    var dateCreated: NSDate
    
    // MARK: Utilities
    func getDateCreatedInFormat(dateFormat: String) -> String {
        let dateFormatter = NSDateFormatter()
        //dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.stringFromDate(self.dateCreated)
    }
}