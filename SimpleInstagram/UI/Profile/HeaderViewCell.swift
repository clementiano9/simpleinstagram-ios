//
//  MediaViewCell.swift
//  SimpleInstagram
//
//  Created by INITS on 23/01/2020.
//  Copyright © 2020 clementozemoya. All rights reserved.
//

import UIKit

class HeaderViewCell: UICollectionReusableView {
    @IBOutlet weak var mediaCount: UILabel!
    
    @IBOutlet weak var profilePic: UIImageView! {
        didSet {
            profilePic.layer.masksToBounds = true
            profilePic.layer.cornerRadius = profilePic.bounds.width / 2
            print("Setting profile pic round corner")
        }
    }
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var followCount: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var bio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Circular image view
        //profilePic.layer.masksToBounds = true
        //profilePic.layer.cornerRadius = profilePic.bounds.width / 2
    }
}
