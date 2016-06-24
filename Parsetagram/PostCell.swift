//
//  PostCell.swift
//  Parsetagram
//
//  Created by Udgam Goyal on 6/21/16.
//  Copyright © 2016 Udgam Goyal. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostCell: UITableViewCell {
    
    
    

    @IBOutlet weak var profPicCell: PFImageView!
    @IBOutlet weak var numLikes: UILabel!
    @IBOutlet weak var postTimestamp: UILabel!
    @IBOutlet weak var imageInPost: PFImageView!
    @IBOutlet weak var userLabel: UILabel!
        
    var instagramPost: PFObject! {
        didSet {
            self.imageInPost.file = instagramPost["media"] as? PFFile
//            self.imageInPost.layer.cornerRadius = self.self.imageInPost.frame.size.width / 10
//            self.imageInPost.clipsToBounds = true
            self.imageInPost.loadInBackground()
        }
    }
    
    @IBOutlet weak var captionInPost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
