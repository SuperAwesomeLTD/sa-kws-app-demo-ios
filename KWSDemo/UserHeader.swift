//
//  UserHeaderTableViewCell.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 10/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class UserHeader: UITableViewCell {

    public static let Identifier: String = "UserHeaderId"
    
    @IBOutlet weak var headerTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
