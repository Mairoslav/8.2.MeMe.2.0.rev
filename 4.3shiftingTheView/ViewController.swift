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
    // outlet for imagePicker
    @IBOutlet weak var imagePickerView: UIImageView! // an outlet to image UIImageView
    
    // outlets for album & camera buttons
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    // outlets for bottom & top textFields
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    
    let imagePicker = UIImagePickerController() // an instance of UIImagePickerController
    
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // call unsubscribeToKeybordNotifications() method in viewWillDissappear
        self.unsubscribeFromKeybordNotification()
    }

    // an action to the button to load the UIImagePickerController
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
        if textField.text == "type your top MeMe" || textField.text == "type your bottom MeMe" {
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
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 21)!,
            NSAttributedString.Key.strokeWidth: -4]
                as [NSAttributedString.Key : Any]
        
        topTextField.attributedPlaceholder = NSAttributedString(string: "type your top MeMe", attributes: textStyle)
               bottomTextField.attributedPlaceholder = NSAttributedString(string: "type your bottom MeMe", attributes: textStyle)
               textField.textAlignment = .center
               textField.delegate = self
        
        textField.defaultTextAttributes = textStyle
        textField.textAlignment = NSTextAlignment.center
    }
    
    // MARK: Moving the view functions
    // When the keyboardWillShow notification is received, shift the view's frame up
    @objc func keybordWillShow(_ notification: Notification) {
        // To move the view up above the keybord, we substract the height of the keybord.
        if bottomTextField.isFirstResponder {
                    print("keyboardWillShow Bottom")
                    view.frame.origin.y = getKeyboardHeight(notification) * (-1)
                }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keybordSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keybordSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
            if bottomTextField.isFirstResponder {
                print("keyboardWillHide Bottom")
                view.frame.origin.y = 0
            }
        }
    
    // MARK: subscribe/sign up to be notified when the keyboard appears
    // see also func func viewWilAppear & viewWillDisappear at the begining of project where I:
        // subscribeToKeyboardNotifications() & unsubscribeFromKeyboardNotifications()
    func subscribeToKeyboardNotifications() {
        // argument of '#selector' refers to instance method 'keybordWillShow' that is not exposed to Objective-C
        // add '@objc' to expose this instance method to Objective-C
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillShow(_: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: unsubscribe 
    func unsubscribeFromKeybordNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}


