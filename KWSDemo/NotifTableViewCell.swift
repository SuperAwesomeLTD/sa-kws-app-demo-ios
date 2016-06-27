//
//  NotifTableViewCell.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 22/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

protocol NotifCellProtocol {
    func notifCellProtocolDidClickOnAction ()
    func notifCellprotocolDidClickOnDocs ()
}

class NotifTableViewCell: UITableViewCell {

    @IBOutlet weak var content: UIView!
    @IBOutlet weak var notifActionButton: UIButton!
    @IBOutlet weak var notifDocButton: UIButton!
    
    var delegate: NotifCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        content.addShadow()
        notifActionButton.blueButton()
        notifDocButton.blueButton()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func notifAction(sender: AnyObject) {
        delegate?.notifCellProtocolDidClickOnAction()
    }
    
    @IBAction func notifDocs(sender: AnyObject) {
        delegate?.notifCellprotocolDidClickOnDocs()
    }
}
