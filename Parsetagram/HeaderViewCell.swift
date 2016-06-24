//
//  HeaderViewCell.swift
//  Parsetagram
//
//  Created by Udgam Goyal on 6/24/16.
//  Copyright © 2016 Udgam Goyal. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HeaderViewCell: UITableViewCell {

    @IBOutlet weak var profPic: PFImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
