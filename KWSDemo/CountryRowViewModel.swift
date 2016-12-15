//
//  TableRowViewModel.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 09/12/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit

class CountryRowViewModel: NSObject, ViewModel {

    private var countryISOCode: String?
    private var countryName: String?
    private var countryFlag: UIImage?
    
    init(isoCode: String) {
        super.init ()
        
        self.countryISOCode = isoCode
        self.countryName = Locale.current.localizedString(forRegionCode: self.countryISOCode!)
        
        let flag = UIImage (named: "\(self.countryISOCode!.lowercased()).png")
        
        if let flag = flag {
            self.countryFlag = flag
        }
    }
    
    func getISOCode () -> String {
        if let code = countryISOCode {
            return code.uppercased()
        } else {
            return "page_country_row_default_country_iso".localized
        }
    }
    
    func getCountryName () -> String {
        if let name = countryName {
            return name.capitalized
        } else {
            return "page_country_row_default_country_name".localized
        }
    }
    
    func getFlag () -> UIImage {
        if let flag = countryFlag {
            return flag
        } else {
            return UIImage (named: ("page_country_row_default_country_flag".localized + ".png"))!
        }
    }
    
}
