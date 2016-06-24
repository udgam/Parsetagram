//
//  ProfileViewController.swift
//  Parsetagram
//
//  Created by Udgam Goyal on 6/23/16.
//  Copyright © 2016 Udgam Goyal. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var profilePictureImage: PFImageView!
    var query = PFQuery(className: "Post")
    @IBOutlet weak var collectionViewProfile: UICollectionView!
    var showedPosts: [PFObject]?
    var isDataLoading = false
    let refreshControl = UIRefreshControl()
    var alertController: UIAlertController!
    var alertController2: UIAlertController!
    var user: PFUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewProfile.dataSource = self
        
        
        //        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        //        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        //        loadingMoreView!.hidden = true
        //        tableView.addSubview(loadingMoreView!)
        
        self.refreshControl.addTarget(self, action: #selector(queryFromParse(_:)), forControlEvents: UIControlEvents.ValueChanged)
        collectionViewProfile.insertSubview(self.refreshControl, atIndex: 0)
        queryFromParse(self.refreshControl)
        
        if let profilePicFile = PFUser.currentUser()!["profilePicture"]{
            self.profilePictureImage.file = profilePicFile as! PFFile
            self.profilePictureImage.layer.cornerRadius = self.profilePictureImage.frame.size.width / 2
            self.profilePictureImage.clipsToBounds = true
            self.profilePictureImage.loadInBackground()
        }
        else{
            
        }
        collectionViewProfile.insertSubview(self.refreshControl, atIndex: 0)
        collectionViewProfile.reloadData()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func queryFromParse(refreshControl: UIRefreshControl){
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        query.whereKey("author", equalTo: PFUser.currentUser()!)
        userLabel.text = PFUser.currentUser()?.username
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                self.showedPosts = posts
                print (self.showedPosts!.count)
                print(self.showedPosts)
            } else {
                print(error?.localizedDescription)
            }
            self.isDataLoading = false
            //self.loadingMoreView!.stopAnimating()
            self.collectionViewProfile.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutAction(sender: AnyObject) {
        
        // PFUser.currentUser() will now be nil
        
        self.alertController = UIAlertController(title: "Log Out?", message: "", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // handle response here.
            
            PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            }
            self.performSegueWithIdentifier("logOut", sender: nil)
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
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let p = self.showedPosts{
            return p.count
        }
        else{
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let totalwidth = collectionView.bounds.size.width;
        let numberOfCellsPerRow = 3
        let dimensions = CGFloat(Int(totalwidth) / numberOfCellsPerRow)
        return CGSizeMake(dimensions, dimensions)
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PostCollectionViewCell", forIndexPath: indexPath) as! PostCollectionViewCell
        
        let post = self.showedPosts![indexPath.row]
        cell.instagramPost = post
        //print("cell")
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != "logOut"{
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionViewProfile.indexPathForCell(cell)
        let post = self.showedPosts![(indexPath?.row)!]
        let detailsViewController = segue.destinationViewController as! DetailsViewController
        detailsViewController.post = post
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    }
    
}






