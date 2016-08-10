//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Jake Malley on 08/08/2016.
//  Copyright © 2016 Jake Malley. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Constants
    let customTextAttributes = [
        NSStrokeColorAttributeName:UIColor.blackColor(),
        NSForegroundColorAttributeName:UIColor.whiteColor(),
        NSFontAttributeName:UIFont(name: "Impact", size: 40)!,
        NSStrokeWidthAttributeName:-4.5,
    ]
    
    let topTextFieldDelegate = MemeTextFieldDelegate(defaultText: "TOP")
    let bottomTextFieldDelegate = MemeTextFieldDelegate(defaultText: "BOTTOM")
    
    // MARK: Outlets
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var pickImageFromCameraButton: UIBarButtonItem!
    @IBOutlet weak var pickImageFromLibraryButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerToolbar: UIToolbar!
    
    // MARK: Actions
    @IBAction func shareButtonPressed(sender: AnyObject) {
        // Generate the memed imaged.
        let memedImage = generateMemedImage()
        // Create the activity view controller.
        let shareActivityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        shareActivityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            
            if success {
                // If the activity was a success save the meme and dismiss.
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }
        // Present the view controller.
        presentViewController(shareActivityViewController, animated: true, completion: nil)
    }

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        // When the cancel button is pressed, dismiss the keyboard.
        //dismissKeyboard()
        // Remove the image.
        //memeImageView.image = nil
        // Reset the text.
        //resetTextFields()
        // Disable the shae button.
        //shareButton.enabled = false
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func pickImageFromCamera(sender: AnyObject) {
        // Pick an image from the camera.
        displayImagePicker(UIImagePickerControllerSourceType.Camera)
    }

    @IBAction func pickImageFromLibrary(sender: AnyObject) {
        // Pick an image from the photo library.
        displayImagePicker(UIImagePickerControllerSourceType.PhotoLibrary)
    }

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // When a user taps, call the dismiss keyboard.
        // Based on: http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MemeEditorViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Configure the textfields.
        configureTextField(topTextField, delegate: topTextFieldDelegate)
        configureTextField(bottomTextField, delegate: bottomTextFieldDelegate)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Display the photo library / camera buttons if they're not available.
        pickImageFromCameraButton.enabled = UIImagePickerController
            .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        pickImageFromLibraryButton.enabled = UIImagePickerController
            .isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
        
        // Subscribe to the keyboard notifications.
        subscribeToKeyboardNotifications()
        
        
        
        // Disabled the share button if there is no image.
        if memeImageView.image == nil {
            shareButton.enabled = false
        } else {
            shareButton.enabled = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe to the keyboard notifications.
        unsubscribeToKeyboardNotifications()
    }
    
    // MARK: Notifications
    func subscribeToKeyboardNotifications(){
        // Subscribe to keyboard show notifications.
        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        // Subscribe to keyboard hide notifications.
        NSNotificationCenter
            .defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications(){
        // Unsubscribe from keyboard show notifications.
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        // Unsubscribe from keyboard hide notifications.
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: Keyboard
    func keyboardWillShow(notification: NSNotification){
        // Adjust the frames's y origin to make room for the keyboard.
        if bottomTextField.isFirstResponder() {
            // Only move the frame if it is the bottom text field.
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        // Reset the frame's y origin to 0. (Top of screen).
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func dismissKeyboard(){
        // Cause view/textfields to resign as first responder.
        view.endEditing(true)
    }
    
    // MARK: TextField
    func configureTextField(textField: UITextField, delegate: MemeTextFieldDelegate){
        // Configure the two text fields.
        textField.defaultTextAttributes = customTextAttributes
        textField.textAlignment = .Center
        textField.delegate = delegate
    }
    
    func resetTextFields() {
        // Reset the text of the text field, to the default text specified in the delegate.
        topTextField.text = topTextFieldDelegate.defaultText
        bottomTextField.text = bottomTextFieldDelegate.defaultText
    }
    
    // MARK: Image Picker
    func displayImagePicker(imageSourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = imageSourceType
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // If the user cancelled, dismiss the image picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.memeImageView.contentMode = UIViewContentMode.ScaleAspectFit
            self.memeImageView.image = image
        }
        // Close the image picker.
        imagePickerControllerDidCancel(picker)
    }
    
    // MARK: Sharing
    func save() {
        // Create new meme.
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: self.memeImageView.image!, memedImaged: generateMemedImage(), dateCreated: NSDate())
        // Add meme to the memes array in the app delegate.
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        // Hide toolbars while we take a photo.
        navigationBar.hidden = true
        imagePickerToolbar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Unhide the tool bars.
        navigationBar.hidden = false
        imagePickerToolbar.hidden = false
        
        return memedImage
    }
}

