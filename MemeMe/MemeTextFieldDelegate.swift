//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Jake Malley on 08/08/2016.
//  Copyright © 2016 Jake Malley. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    let defaultText: String
    
    init(defaultText:String) {
        self.defaultText = defaultText
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // When the Done/Return button is pressed, hide the keyboard.
        textField.resignFirstResponder()
        // Continue default behavior.
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == defaultText {
            // If we begin editing and the default text is there, delete it.
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text?.characters.count <= 0 {
            // If the text field is empty after editing, replace the default text.
            textField.text = defaultText
        }
    }
    
}