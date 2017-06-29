//
//  MainController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 29/06/2017.
//  Copyright © 2017 Gabriel Coman. All rights reserved.
//

import UIKit

class MainController: KWSBaseController {

    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var platformContainer: UIView!
    @IBOutlet weak var featuresContainer: UIView!
    @IBOutlet weak var docsContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.layer.masksToBounds = false
        headerView.layer.shadowOffset = CGSize(width: 0, height: 3.5)
        headerView.layer.shadowRadius = 1
        headerView.layer.shadowOpacity = 0.125
    }
    
    @IBAction func indexChanged(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            platformContainer.isHidden = false
            featuresContainer.isHidden = true
            docsContainer.isHidden = true
            break
        case 1:
            platformContainer.isHidden = true
            featuresContainer.isHidden = false
            docsContainer.isHidden = true
            break
        case 2:
            platformContainer.isHidden = true
            featuresContainer.isHidden = true
            docsContainer.isHidden = false
            break
        default:
            break;
        }
    }
}
