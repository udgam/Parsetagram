//
//  PostCollectionViewCell.swift
//  Parsetagram
//
//  Created by Udgam Goyal on 6/23/16.
//  Copyright © 2016 Udgam Goyal. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var captionInPost: UILabel!
    @IBOutlet weak var imageInPost: PFImageView!
    var instagramPost: PFObject! {
        didSet {
            self.imageInPost.file = instagramPost["media"] as? PFFile
            self.imageInPost.loadInBackground()
        }
    }
}
