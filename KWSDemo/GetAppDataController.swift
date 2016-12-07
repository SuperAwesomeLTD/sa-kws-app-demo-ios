//
//  AppDataGetControllerViewController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 01/09/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class GetAppDataController: UIViewController/*, KWSPopupNavigationBarProtocol*/ {

    @IBOutlet weak var appDataTable: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }

    @IBAction func addNewNameValuePairAction(_ sender: AnyObject) {
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let vc = sb.instantiateViewController(withIdentifier: "SetAppDataNavControllerId")
//        present(vc, animated: true, completion: nil)
    }
    
//    // MARK: KWSPopupNavigationBarProtocol
//    
//    func kwsPopupNavGetTitle() -> String {
//        return "get_app_data_vc_title".localized
//    }
//    
//    func kwsPopupNavDidPressOnClose() {
//        dismiss(animated: true) {
//            // flush
//        }
//    }
}
