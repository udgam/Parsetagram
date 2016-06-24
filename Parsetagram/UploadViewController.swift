//
//  UploadViewController.swift
//  Parsetagram
//
//  Created by Udgam Goyal on 6/20/16.
//  Copyright © 2016 Udgam Goyal. All rights reserved.
//

import UIKit
import Parse

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    var currentImage: UIImage!
    @IBOutlet weak var imageToUpload: UIImageView!
    var currentPost = Post()
    var size = CGSizeMake(350,350)
    
    @IBOutlet weak var captionLabel: UITextField!
    
    @IBOutlet weak var captionText: UITextField!
    var alertController: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captionLabel.delegate = self
        //        let uploadButton = UIButton(frame: CGRect(x: 122, y: 38, width: 123, height: 97))
        //        uploadButton.addTarget(self, action: #selector(importPicture), forControlEvents: .TouchUpInside)
        //        uploadButton.setTitle("TEST", forState: UIControlState.Normal)
        //        uploadButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        //        self.view.addSubview(uploadButton)
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func uploadButtonSB(sender: AnyObject) {
        importPicture(false)
    }
    @IBAction func takePicture(sender: AnyObject) {
        importPicture(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func importPicture(camera: Bool) {
        let picker = UIImagePickerController()
        if (camera){
            picker.sourceType = UIImagePickerControllerSourceType.Camera
        }
        else{
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        picker.allowsEditing = true
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var newImage: UIImage
        
        if let possibleImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        dismissViewControllerAnimated(true, completion: nil)
        currentImage = newImage
        imageToUpload.image = resize(currentImage, newSize: size)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    @IBAction func uploadAction(sender: AnyObject) {
        
        
        self.alertController = UIAlertController(title: "Upload Picture to Parsetagram?", message: "", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            // handle response here.
            
            
            Post.postUserImage(self.currentImage, withCaption: self.captionText.text, withCompletion: nil)
            let alertController2 = UIAlertController(title: "Picture Uploaded!", message: "", preferredStyle:.Alert)
            let OKAction2 = UIAlertAction(title:"OK",style: .Default){(action) in }
            alertController2.addAction(OKAction2)
            self.presentViewController(alertController2, animated: true){}
            
        }
        // add the OK action to the alert controller
        self.alertController.addAction(OKAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        self.alertController.addAction(cancelAction)
        self.presentViewController(self.alertController, animated: true) {
            // optional code for what happens after the alert controller has finished presenting
        }
        
    }
    
    
    @IBAction func uploadProfilePictureAction(sender: AnyObject) {
        
        
        self.alertController = UIAlertController(title: "Upload Profile Picture?", message: "", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            // handle response here.
            let user = PFUser.currentUser()
            user!["profilePicture"] = self.getPFFileFromImage(self.currentImage)
            user?.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
            })
            let alertController2 = UIAlertController(title: "Picture Uploaded!", message: "", preferredStyle:.Alert)
            let OKAction2 = UIAlertAction(title:"OK",style: .Default){(action) in }
            alertController2.addAction(OKAction2)
            self.presentViewController(alertController2, animated: true){}
            
        }
        
        // add the OK action to the alert controller
        self.alertController.addAction(OKAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        self.alertController.addAction(cancelAction)
        self.presentViewController(self.alertController, animated: true) {
            // optional code for what happens after the alert controller has finished presenting
        }
        
        
        
    }
    
    func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
