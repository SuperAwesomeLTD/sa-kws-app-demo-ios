//
//  CountryController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 09/12/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol CountryProtocol {
    func didSelectCountry(isoCode: String, name: String, flag: UIImage)
}

class CountryController: KWSBaseController {

    // outlets
    @IBOutlet weak var countrySearch: KWSTextField!
    @IBOutlet weak var countryTable: UITableView!
    
    // delegate
    var delegate: CountryProtocol?
    
    // create data source
    private var dataSource: RxDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "country_vc_title".localized
        
        // view setup
        countrySearch.placeholder = "country_search_placeholder".localized
        
        // search
        countrySearch.rx.text.orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { (query) -> [String] in
                let query = query.lowercased()
                let isEmpty = query.isEmpty
                return NSLocale.isoCountryCodes.filter({ (isoCode) -> Bool in
                    let name = Locale.current.localizedString(forRegionCode: isoCode)?.lowercased()
                    return name!.contains(query) || isEmpty

                })
            }
            .subscribe(onNext: { (filteredCountryCodes: [String]) in
                
                Observable.from(filteredCountryCodes)
                    .map { (countryCode) -> CountryRowViewModel in
                        return CountryRowViewModel(isoCode: countryCode)
                    }
                    .toArray()
                    .subscribe(onNext: { (countries: [CountryRowViewModel]) in
                      
                        // create data source
                        self.dataSource = RxDataSource
                            .bindTable(self.countryTable)
                            .customiseRow(cellIdentifier: CountryRow.Identifier,
                                          cellType: CountryRowViewModel.self,
                                          cellHeight: 50)
                            { (model, cell) in
                                
                                let cell = cell as? CountryRow
                                let model = model as? CountryRowViewModel
                                
                                cell?.countryName.text = model?.getCountryName()
                                cell?.flagIcon.image = model?.getFlag()
                                
                            }
                            .clickRow(cellIdentifier: CountryRow.Identifier) { (index, model) in
                                
                                if let model = model as? CountryRowViewModel {
                                    
                                    self.delegate?.didSelectCountry(isoCode: model.getISOCode(),
                                                                    name: model.getCountryName(),
                                                                    flag: model.getFlag())
                                    
                                    _ = self.navigationController?.popViewController(animated: true)
                                }
                            }
                        
                        // update
                        self.dataSource?.update(countries)
                        
                    })
                    .addDisposableTo(self.disposeBag)
                
            })
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
