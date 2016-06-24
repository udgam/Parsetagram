//
//  HomeViewController.swift
//  Parsetagram
//
//  Created by Udgam Goyal on 6/20/16.
//  Copyright © 2016 Udgam Goyal. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import MBProgressHUD

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
    var isHome = true
    var alertController: UIAlertController!
    var query = PFQuery(className: "Post")
    
    var feed: String = ""
    
    var showedPosts: [PFObject]?
    var isDataLoading = false
    let refreshControl = UIRefreshControl()
    var loadingMoreView:InfiniteScrollActivityView?
    var limit = 20
    var addedEachScroll = 2
    

    @IBOutlet weak var tableView: UITableView!
    
    let CellIdentifier = "TableViewCell"
    let HeaderViewIdentifier = "TableViewHeaderView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        self.refreshControl.addTarget(self, action: #selector(queryFromParse(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(self.refreshControl, atIndex: 0)
        queryFromParse(self.refreshControl)
        
        
        
        
    }
    
    func queryFromParse(refreshControl: UIRefreshControl){
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = self.limit
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if let posts = posts {
                self.showedPosts = posts
                print (self.showedPosts!.count)
                print(self.showedPosts)
            } else {
                print(error?.localizedDescription)
            }
            self.isDataLoading = false
            self.loadingMoreView!.stopAnimating()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if self.showedPosts?.count > 0{
            return 1
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostCell
        let post = self.showedPosts![indexPath.section]
        cell.instagramPost = post
        cell.captionInPost.text = post["caption"] as? String
//        let author =  post["author"] as? PFUser
//        if let a = author!["profilePicture"]{
//        }
        let parsedTimestamp = post.createdAt
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        cell.postTimestamp.text = dateFormatter.stringFromDate(parsedTimestamp!)
        cell.numLikes.text = "\(post["likesCount"])"
        let author =  post["author"] as? PFUser
        if let a = author!["profilePicture"]{
        cell.profPicCell.file = author!["profilePicture"] as! PFFile
        cell.profPicCell.layer.cornerRadius = cell.profPicCell.frame.size.width / 2
        cell.profPicCell.clipsToBounds = true
        cell.profPicCell.loadInBackground()
        }
        cell.userLabel.text = post["author"].username
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let p = self.showedPosts{
            return p.count
        }
        else{
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderViewIdentifier)! as UITableViewHeaderFooterView
        //let header = tableView.dequeueReusableCellWithIdentifier("HeaderViewCell") as! HeaderViewCell
        let post = self.showedPosts![section]
        header.textLabel!.text = post["author"].username
//        let author =  post["author"] as? PFUser
//        if let a = author!["profilePicture"]{
//        header.profPic.file = author!["profilePicture"] as! PFFile
//        header.profPic.layer.cornerRadius = header.profPic.frame.size.width / 2
//        header.profPic.clipsToBounds = true
//        header.profPic.loadInBackground()
//        }
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isDataLoading = true
                
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                self.limit += addedEachScroll
                // Code to load more results
                queryFromParse(self.refreshControl)
            }
        }
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let post = self.showedPosts![(indexPath?.section)!]
        let detailsViewController = segue.destinationViewController as! DetailsViewController
        detailsViewController.post = post
        
        
        
        
        
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    
}