//
//  ViewController.swift
//  4.3shiftigTheView
//
//  Created by mairo on 19/03/2022.
//

import UIKit

// Add two protocols to the class declaration: UIImagePickerControllerDelegate, UINavigationControllerDelegate
// Add third protocol to the class declaration: UItextFieldDelegate


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: Outlets
    @IBOutlet weak var imagePickerView: UIImageView! // imagePickerView
    
    @IBOutlet weak var albumButton: UIBarButtonItem! // album
    @IBOutlet weak var cameraButton: UIBarButtonItem! // camera
    
    @IBOutlet weak var topTextField: UITextField! // top text
    @IBOutlet weak var bottomTextField: UITextField! // bottom text
    
    @IBOutlet weak var topNavBar: UINavigationBar! // top navigation bar ...
    @IBOutlet weak var toolbar: UIToolbar! // toolbar ...
    
    @IBOutlet weak var shareButton: UIBarButtonItem! // share ...
    @IBOutlet weak var cancelButton: UIBarButtonItem! // cancel ...
    
    let imagePicker = UIImagePickerController() // an instance of UIImagePickerController
    
    // MARK: view-DidLoad/willAppear/willDisappear
    override func viewDidLoad() {
        super.viewDidLoad()
        // set View Controller as the delegate for the UIImagePickerController
        // denoting that “self” is the delegate for the imagePicker, bottomTextField, topTextField
        imagePicker.delegate = self
        // bottomTextField.delegate = self // need when text style via storyboard
        // topTextField.delegate = self // need when text style via storyboard
        
        // need when text style progamaticaly via method configureTextField(textField: UITextField)
        configureTextField(textField: bottomTextField)
        configureTextField(textField: topTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // disable the camera button in cases when this bool returns false for the camera sourceType
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        // call subscribeToKeybordNotifications() method in viewWillAppear
        self.subscribeToKeyboardNotifications()
        
        // if there's an image in the imageView, enable the share button
        if let _ = imagePickerView.image {
            shareButton.isEnabled = true
        } else {
            shareButton.isEnabled = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // call unsubscribeToKeybordNotifications() method in viewWillDissappear
        self.unsubscribeFromKeybordNotification()
    }

    // MARK: actions to the buttons to load the UIImagePickerController
    // we’ll call up the UIImagePickerController here
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary // an image is coming from the album
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera // an image is coming from the camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Method I.
    // to read the Image Picked from UIImagePickerController - so that selected picture appears in UIImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // will send the data back for us to use in that Swift Dictionary named “info”
        // we have to unpack it from there with a key asking for what media information we want.
        // we just want the image, so that is what we ask for. For reference, the available options of UIImagePickerController.InfoKey are: mediaType, originalImage, editedImage...
        // we got out that part of the dictionary and optionally bound its type-casted form as a UIImage into the constant “pickedImage”.
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // setting the “content mode” of the UIImageView.
            // imagePickerView.contentMode = .scaleToFill // distorted
            // imagePickerView.contentMode = .scaleAspectFit // fit view, minimized to avoid distortion
            imagePickerView.contentMode = .scaleAspectFill // fit view, clipped to avoid distortion
            imagePickerView.image = pickedImage // sets the image of the UIImageView to be the image we just got pack.
            
            // inside didFinishPickingMediaWithInfo we enable the share button to use it
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil) // dismiss image picker after xy image is selected
    }
    
    // MARK: - UIImagePickerControllerDelegate Method II.
    // is called when the user taps the “Cancel” button on top left of image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil) // dismiss image picker after button "Cancel" is pressed
    }
    
    // MARK: Text Field Delegate
    // when a user taps inside the textfiels the default text should clear
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "top MeMe" || textField.text == "bottom MeMe" {
            textField.text = ""
        }
    }
    
    // MARK: Text Field Delegate
    // when a user presses return, the keyboard should be dismissed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - text style in textFields
    func configureTextField(textField: UITextField) {
        let textStyle: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
            NSAttributedString.Key.strokeWidth: -4]
                as [NSAttributedString.Key : Any]
        
        topTextField.attributedPlaceholder = NSAttributedString(string: "top MeMe", attributes: textStyle)
               bottomTextField.attributedPlaceholder = NSAttributedString(string: "bottom MeMe", attributes: textStyle)
               textField.textAlignment = .center
               textField.delegate = self
        
        textField.defaultTextAttributes = textStyle
        textField.textAlignment = NSTextAlignment.center
    }
    
    // MARK: Moving the view functions
    // how do we know when the keybord is about to slide up?
    // NSNotifications provide a way to notice information throughout the program across classes
    // to anounce infomration like the keybord does show/hide, get info on keybord height...
    @objc func keybordWillShow(_ notification: Notification) {
        // To move the view up above the keybord, frame view is reduced by the height of keybord vs original vertical position (y)
        if bottomTextField.isFirstResponder {
                    view.frame.origin.y = getKeyboardHeight(notification) * (-1)
                }
    }
    
    // get keybord height
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keybordSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keybordSize.cgRectValue.height
    }
    
    // keybord does hide, frame view is again in original vertical position (y)
    @objc func keyboardWillHide(_ notification: Notification) {
            if bottomTextField.isFirstResponder {
                view.frame.origin.y = 0
            }
        }
    
    // MARK: subscribe/sign up to be notified when the keyboard appears
    // see also func func viewWilAppear & viewWillDisappear at the begining of project where the:
        // subscribeToKeyboardNotifications() & unsubscribeFromKeyboardNotifications() methods are called
    func subscribeToKeyboardNotifications() {
        // argument of '#selector' refers to instance method 'keybordWillShow' that is not exposed to Objective-C
        // add '@objc' to expose this instance method to Objective-C
        // NotificationCenter.default.addObserver(<#T##observer: Any##Any#>, selector: <#T##Selector#>, name: <#T##NSNotification.Name?#>, object: <#T##Any?#>)
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillShow(_: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: unsubscribe
    func unsubscribeFromKeybordNotification() {
        // NotificationCenter.default.removeObserver(<#T##observer: Any##Any#>, name: <#T##NSNotification.Name?#>, object: <#T##Any?#>)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // Every iOS program has one default NotificationCenter, NotificationCenter.default which comes with a number of useful stock notifications, like .UIKeyboardWillShow
    // https://developer.apple.com/documentation/foundation/notification
    
    // MARK: making object to represent MeMe
    // combining image and text
    // grab an image context and let it render the view hierarchy (image & textfields in this case) into a UIImage object.
    func generateMemedImage() -> UIImage {
        
        //Hide Toolbar And Navigation Bar
        topNavBar.isHidden = true
        toolbar.isHidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Show Toolbar and Navigation Bar
        topNavBar.isHidden = false
        toolbar.isHidden = false
        
        return memedImage
    }
    
    // MARK: struct
    // for each individual meme object need struct that includes the following component properties:
    struct Meme {
        var topText: String = ""
        var bottomText: String = ""
        var image: UIImage?
        var memedImage: UIImage?
    }
    
    // MARK: save
    // method that initializes a Meme model object
    func save() {
        
        // get the image from the imagePickerView
        let imageView = imagePickerView.image // without this let, in let meme just "image: imagePickerView.image"
        
        // create the meme
        let memedImage = generateMemedImage()
        
        // pack the layers on each other using components from struct set above
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imageView, memedImage: memedImage)
        
        // variable to store memes
        var memes = [Meme]() // instead of forced unwrap var memes: [Meme]! use as it is now
        memes.append(meme)
    }
    
    // MARK: share
    @IBAction func share(_ sender: Any) {
        // generate memed image
        let memedImage = generateMemedImage()
        
        // define an instance of ActivityViewController
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        // so that iPads won't crash
        activityVC.popoverPresentationController?.sourceView = self.view
        
        // pass the ActivityViewController a memedImage as an activity item
        activityVC.completionWithItemsHandler = { activity, success, items, error in
            self.save()
            self.dismiss(animated: true, completion: nil)
        }
        
        // present the VC
        present(activityVC, animated: true, completion: nil)
    }

    // MARK: cancel
    @IBAction func cancel(_ sender: Any) {
        topTextField.text = "top MeMe"
        bottomTextField.text = "bottom MeMe"
        self.imagePickerView.image = nil
    }
}

/*
 Sources used:
 Udacity iOS Nanodegree lessons
 https://www.codingexplorer.com/choosing-images-with-uiimagepickercontroller-in-swift/
 https://stackoverflow.com/questions/35931946/basic-example-for-sharing-text-or-image-with-uiactivityviewcontroller-in-swift
 */



