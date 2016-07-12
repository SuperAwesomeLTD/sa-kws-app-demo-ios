//
//  NotifTableViewCell.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 22/06/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

protocol NotifCellProtocol {
    func notifCellProtocolDidClickOnEnable ()
    func notifCellProtocolDidClickonDisable ()
    func notifCellprotocolDidClickOnDocs ()
}

class NotifTableViewCell: UITableViewCell {

    @IBOutlet weak var content: UIView!
    @IBOutlet weak var notifEnableButton: UIButton!
    @IBOutlet weak var notifDisableButton: UIButton!
    @IBOutlet weak var notifDocButton: UIButton!
    
    var delegate: NotifCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        content.addShadow()
        notifEnableButton.blueButton()
        notifDisableButton.blueButton()
        notifDocButton.blueButton()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func notifEnableAction(sender: AnyObject) {
        delegate?.notifCellProtocolDidClickOnEnable()
    }
    
    @IBAction func notifDisableAction(sender: AnyObject) {
        delegate?.notifCellProtocolDidClickonDisable()
    }
    
    @IBAction func notifDocsAction(sender: AnyObject) {
        delegate?.notifCellprotocolDidClickOnDocs()
    }
}
