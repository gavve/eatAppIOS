//
//  ProfilePicVC.swift
//  Eat App
//
//  Created by vmware on 27/06/16.
//  Copyright © 2016 LiU. All rights reserved.
//

import AVFoundation
import UIKit
//-------------------------------------------------------------------------------------------------------


//-------------------------------------------------------------------------------------------------------

class ProfilePicVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var draggableImageView: UIImageView!
    var image: UIImage?
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.draggableImageView.image = UIImage(named: "defaultProfilePic")

    }
    
    // MARK: Methods for button
    @IBAction func handleChoosePicture(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.draggableImageView.contentMode = .ScaleAspectFill
            self.draggableImageView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "savedProfilePicture" {
            // Skickar tillbaka den valda profilbilden

        }
    }
}
