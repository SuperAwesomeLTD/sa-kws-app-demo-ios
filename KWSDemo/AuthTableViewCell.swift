//
//  AuthTableViewCell.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 22/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

protocol AuthCellProtocol {
    func authCellProtocolDidClickOnAction ()
    func authCellprotocolDidClickOnDocs ()
}

class AuthTableViewCell: UITableViewCell {
    
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var authActionButton: UIButton!
    @IBOutlet weak var authDocsButton: UIButton!
    
    var delegate: AuthCellProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        // customize
        content.addShadow()
        authActionButton.blueButton()
        authDocsButton.blueButton()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func authAction(sender: AnyObject) {
        delegate?.authCellProtocolDidClickOnAction()
    }
    
    @IBAction func authDocs(sender: AnyObject) {
        delegate?.authCellprotocolDidClickOnDocs()
    }
}
