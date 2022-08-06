//
//  EditMemeViewController.swift
//  4.0meMeV1.0
//
//  Created by mairo on 19/03/2022.
//

import UIKit

// Add two protocols to the class declaration: UIImagePickerControllerDelegate, UINavigationControllerDelegate
// Add third protocol to the class declaration: UItextFieldDelegate

class EditMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var topNavBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var doneButton: UIBarButtonItem! // @@@
    
    var savedMemeForEdit: Meme! // to enable editing saved meme in detail view, had to change ? to !
    
    var memeIsModified = false // for done button to show only when already saved memeIsModified
    
    var indexX: Int? // to replace the meme image at given index when editing it
    
    var imagePicker = UIImagePickerController() // an instance of UIImagePickerController
    
    var textField: UITextField!
    
    // MARK: view-DidLoad/willAppear/willDisappear
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set View Controller as the delegate for the UIImagePickerController
        // denoting that “self” is the delegate for the imagePicker, bottomTextField, topTextField
        imagePicker.delegate = self
        // bottomTextField.delegate = self // need when text style via storyboard
        // topTextField.delegate = self // need when text style via storyboard
        
        // need when text style progamaticaly via method configureTextField(textField: UITextField)
        configureTextField(textField: topTextField,styledDefaultInput: "")
        configureTextField(textField: bottomTextField, styledDefaultInput: "")
        
        // show done button only when already saved memeIsModified = true
        showHideDoneButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false // deleted self. from beggining
        // when accessing properties or methods on self, leave the reference to self implicit by default
        // only include the explicit keyword when required by the language—for example, in a closure, or when parameter names conflict
        
        // disable the camera button in cases when this bool returns false for the camera sourceType
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // call subscribeToKeybordNotifications() method in viewWillAppear
        // to allow the view to raise when keybord does show up
        subscribeToKeyboardNotifications()
        
        // if there's not yet image in the imageView, disable the share button
        // shareButton.isEnabled = false
        
        // to enable editing saved meme in detail view
        if let savedMemeForEdit = savedMemeForEdit as Meme? {
            imagePickerView.image = savedMemeForEdit.image
            topTextField.text = savedMemeForEdit.topText
            bottomTextField.text = savedMemeForEdit.bottomText
        } // or can use code below
        
        /*
        if (savedMemeForEdit != nil) {
            code ...
        }
        */
        
        showHideDoneButton() // show done button only when already saved memeIsModified = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // call unsubscribeToKeybordNotifications() method in viewWillDissappear
        unsubscribeFromKeybordNotification()
    }

    // MARK: actions to the buttons to load the UIImagePickerController
    // we’ll call up the UIImagePickerController here
    
    // creating this reusable method, one that is repeated for album and camera @IBActions methods that follow after this method, see sourceType parameter
    func pickImage(sourceType: UIImagePickerController.SourceType) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
        }
    
    // picking an image from Album
    @IBAction func album(_ sender: Any) {
        pickImage(sourceType: .photoLibrary)
    }
    
    // taking an image via camera
    @IBAction func camera(_ sender: Any) {
        pickImage(sourceType: .camera)
    }
    
    // MARK: - UIImagePickerControllerDelegate Method I. - picture to appear
    
    // to read the Image Picked from UIImagePickerController - so that selected picture appears in UIImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // will send the data back for us to use in that Swift Dictionary named “info”
        // we have to unpack it from there with a key asking for what media information we want.
        // we just want the image, so that is what we ask for. For reference, the available options of UIImagePickerController.InfoKey are: mediaType, originalImage, editedImage...
        // we got out that part of the dictionary and optionally bound its type-casted form as a UIImage into the constant “pickedImage”.
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // setting the “content mode” of the UIImageView.
            // imagePickerView.contentMode = .scaleToFill // distorted
            imagePickerView.contentMode = .scaleAspectFit // fit view, minimized to avoid distortion
            // imagePickerView.contentMode = .scaleAspectFill // fit view, clipped to avoid distortion
            imagePickerView.image = pickedImage // sets the image of the UIImageView to be the image we just got pack.
            
            shareButton.isEnabled = true // once we have picture we enable share button
            showHideDoneButton() // show done button only when already saved memeIsModified = true
        }
        dismiss(animated: true, completion: nil) // dismiss image picker after xy image is selected
    }
    
    // MARK: - UIImagePickerControllerDelegate Method II. - picture to be cancelled
    
    // is called when the user taps the “Cancel” button on top left of image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil) // dismiss image picker after button "Cancel" is tapped
    }
    
    // MARK: Text Field Delegate I. - default text to clear when user starts typing
    
    // when a user taps inside the textfiels the default text should clear
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "HEADER" || textField.text == "FOOTER" {
            textField.text = ""
        }
    }
    
    // MARK: Text Field Delegate II. - keybord to get down after tapping return/enter
    
    // when a user presses return/enter, the keyboard should be dismissed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Text style in textFields
    
    // configureTextField is declared in viewDidLoad()
    func configureTextField(textField: UITextField, styledDefaultInput: String) {
        let textStyle: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Impact", size: 35)!,
            NSAttributedString.Key.strokeWidth: -4]
                as [NSAttributedString.Key : Any]
        
        // instead of repeating this line(s),added a new parameter styledDefaultInput: String to method configureTextField
        // topTextField.attributedPlaceholder = NSAttributedString(string: "HEADER", attributes: textStyle)
        // bottomTextField.attributedPlaceholder = NSAttributedString(string: "FOOTER", attributes: textStyle)
        
        var styledDefaultInput = "HEADER"
        topTextField.text = styledDefaultInput
        styledDefaultInput = "FOOTER"
        bottomTextField.text = styledDefaultInput
        
        textField.delegate = self
        
        textField.defaultTextAttributes = textStyle
        
        // textField.layer.borderWidth = 0
        // textField.layer.borderColor = UIColor.clear.cgColor
        // ↪ no, go identity inspector/Border style/none or code below
        
        // no border style to avoid thin line on screen - visible also with code above
        textField.borderStyle = .none
        
        // because UIKeyboardType.numberPad, .phonePad,.namePhonePad do not support autocapitalization
        textField.keyboardType = .webSearch
        
        textField.autocorrectionType = .no
       
        // code below or mainStoryboard/TextField/TextInputTraits/Capitalization
        textField.autocapitalizationType = .allCharacters // why does not work?
        // If using your hardware e.g iPhone keyboard, it ignores auto capitalization
        // If using the keypad on the simulator screen, it should auto-capitalize the .words, .allCharacters... as per selection
        
        // text to shrink when it does start to exceeding the textField
        // code below or mainStoryboard/TextField/AdjustToFit
        textField.adjustsFontSizeToFitWidth = true
        
        textField.textAlignment = .center // or alternative way below, but no need to state NSTextAlignment., similar with "textField.borderStyle = UITextField.BorderStyle.none", and others - enough as above
        // textField.textAlignment = NSTextAlignment.center
        
    }
    
    // MARK: Moving the view functions
    
    // how do we know when the keybord is about to slide up?
    // NSNotifications provide a way to notice information throughout the program across classes
    // to anounce information like the keybord does show/hide, here get info on keybord height...
    @objc func keybordWillShow(_ notification: Notification) {
        // To move the view up above the keybord, frame view is reduced by the height of keybord vs original vertical position (y)
        if bottomTextField.isFirstResponder {
            // view.frame.origin.y = getKeyboardHeight(notification) * (-1)
            view.frame.origin.y = -getKeyboardHeight(notification)
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillShow(_: )), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: unsubscribe
    
    func unsubscribeFromKeybordNotification() {
        // NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        // NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        // or can remove two above observers at once like this:
        NotificationCenter.default.removeObserver(self)
    }
    // Every iOS program has one default NotificationCenter, NotificationCenter.default which comes with a number of useful stock notifications, like .UIKeyboardWillShow
    // https://developer.apple.com/documentation/foundation/notification
    
    // MARK: making object to represent MeMe
    
    // combining image and text
    // grab an image context and let it render the view hierarchy (image & textfields in this case) into a UIImage object ~ "blend meme"
    func generateMemedImage() -> UIImage {
        
        //Hide Toolbar And Navigation Bar
        topNavBar.isHidden = true
        toolbar.isHidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    // MARK: save
    
    // method that initializes a Meme model object
    func save() {
        
        // get the image from the imagePickerView
        let imageView = imagePickerView.image
        
        // "blend meme"
        let memedImage = generateMemedImage()
        
        // pack the layers on each other using components from struct set above 
        let meme = Meme(topText: topTextField.text ?? String(), bottomText: bottomTextField.text ?? String(), image: imageView ?? UIImage(), memedImage: memedImage ) // with init, see file MemeStruct
        
        // so that I can access appDelegate in the scope of current file
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
            appDelegate.memes.append(meme) // add the meme to the memes array in the AppDelegate.swift
        
    }
    
    // MARK: share
    
    @IBAction func share(_ sender: Any) {
        
        // "blend meme"
        let memedImage = generateMemedImage()
        
        // define an instance of ActivityViewController
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        // so that iPads won't crash
        activityVC.popoverPresentationController?.sourceView = self.view
        
        // pass the ActivityViewController a memedImage as an activity item
        // when sharing the meme, the save function must not be called if the user decides to cancel the activity view. Therefore adding an if statement here checking the success property.
        activityVC.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save() 
                self.dismiss(animated: true, completion: nil)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        // present the VC
        present(activityVC, animated: true, completion: nil)
    }
    
    // MARK: cancel
    
    // cancel button to reset editor to HEADER,FOOTER, noImage and return user to the Sent Memes View
    @IBAction func cancel(_ sender: Any) {
        topTextField.text = "HEADER"
        bottomTextField.text = "FOOTER"
        self.imagePickerView.image = nil
        shareButton.isEnabled = false // no picture no share button
        dismiss(animated: true, completion: nil)
    }
    
    // show done button only when already saved memeIsModified = true
    func showHideDoneButton() {
        let showDone = memeIsModified
        doneButton!.tintColor = showDone ? view.tintColor : UIColor.clear
        // doneButton!.isEnabled = show ? true : false // grey font of done becomes blue
    }
        
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        
        // "blend meme"
        let memedImage = generateMemedImage()
        
        // to put together layers of modified meme, texts, image and final "blended" memedImage
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image ?? UIImage(), memedImage: memedImage) // with init, see file MemeStruct
        
        // so that I can access appDelegate in the scope of current file
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
            appDelegate.memes[indexX ?? Int()] = meme // to replace the meme image at given index after modifying it
        
         
        // after tapping done, modifications happen and below code returns user to the a) table view
        // EditMemeViewController as self does performSegue with ID to return user to the MemeTableViewController
        // self.performSegue(withIdentifier: "unwindSegueToMemeTableViewController", sender: self)
        
        // or alternative code:
        
        /*
        let tabBarController = self.storyboard!.instantiateViewController(withIdentifier: "TabBarControllerInitialController") as! UITabBarController
        present(tabBarController, animated: true, completion: nil)
        */
        
        // after tapping done, modifications happen and below code returns user to the b) detail view
        dismiss(animated: true, completion: nil)
        // modifications happen in array, table & collection however are not yet reflected in the Meme Detail
        // how can I reflect/display changes in MemeDetailViewController right after pressing done button?
        
        // to update the MemeDetail View you can
        // have an additional property for the index - so that you know which image was and
        // access it (index/image) again from the shared array in the app delegate
        // and not from the previously passed meme property
         
    }
    
}






