//
//  UserItemTableViewCell.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 10/08/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class UserRow: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
