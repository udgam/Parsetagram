//
//  DetailsViewController.swift
//  Parsetagram
//
//  Created by Udgam Goyal on 6/23/16.
//  Copyright © 2016 Udgam Goyal. All rights reserved.
//

import UIKit
import ParseUI
import Parse

class DetailsViewController: UIViewController {

    @IBOutlet weak var numLikes: UILabel!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var imageInPostDetails: PFImageView!
    var post: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captionLabel.text = post["caption"] as? String
        userLabel.text = post["author"].username
        let imagePf = post["media"] as? PFFile
        let parsedTimestamp = post.createdAt
        //let strDate = parsedTimestamp?.description
//        timeLabel.text = strDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        timeLabel.text = dateFormatter.stringFromDate(parsedTimestamp!)
        imageInPostDetails.file = imagePf
        imageInPostDetails.loadInBackground()
        numLikes.text = "\(post["likesCount"])"
        //print("Current User:\(PFUser.currentUser()?.username)")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func likeAction(sender: AnyObject) {
        
        let likeCount = post["likesCount"] as! Int
        post["likesCount"] = likeCount + 1
        post.saveInBackground()
        numLikes.text = "\(post["likesCount"])"
    
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
