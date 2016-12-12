//
//  RxDataSource2.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 09/12/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SAUtils

class RxDataSource2: NSObject, UITableViewDelegate, UITableViewDataSource {

    var key: Int
    var table: UITableView?
    var data: [Any] = []
    fileprivate var viewModelToRxRow: [String : RxDataRow] = [:]
    fileprivate var clickMap: [String : (IndexPath, Any)->()] = [:]
    
    init (key: Int) {
        self.key = key
        super.init()
    }
    
    fileprivate func setDataSourceTable (_ table: UITableView) {
        self.table = table
    }
    
    fileprivate func setDataSourceData (_ data: [Any]) {
        self.data = data
    }
    
    fileprivate func addToKey (key: String, row: RxDataRow) {
        viewModelToRxRow[key] = row
        print("Map is \(self.viewModelToRxRow)")
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dt = data[indexPath.row]
        let key = "\(type(of: dt))"
        let row = viewModelToRxRow [key]
        let height = row?.cellHeight ?? 0
        
        return height
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dt = data[indexPath.row]
        let key = "\(type(of: dt))"
        let row = viewModelToRxRow [key]
        
        let cellId = row?.cellIdentifier ?? ""
        let cellFunc = row?.customise
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cellFunc? (dt, cell)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dt = data[indexPath.row]
        let key = "\(type(of: dt))"
        let row = viewModelToRxRow [key]
        
        let cellID = row?.cellIdentifier ?? ""
        let clickFunc = clickMap[cellID]
        
        clickFunc? (indexPath, dt)
        
    }
    
    func update () -> Void {
        
        table?.delegate = self
        table?.dataSource = self
        
        self.data = self.data.filter { (element: Any) -> Bool in
            let key = "\(type(of: element))"
            return self.viewModelToRxRow[key] != nil
        }
        
        self.table?.reloadData()
    }
    
}

private struct RxDataRow {
    public var cellIdentifier: String
    public var cellHeight: CGFloat
    public var customise: ((Any, UITableViewCell) -> ())
}

extension Observable {
    
    func bindTable2 (_ table: UITableView) -> Observable {
        
        return self.do(onNext: { (element) in
            
            let key = SAUtils.randomNumberBetween(1000, maxNumber: 2500)
            let dataSource = RxDataSource2 (key: key)

            if let data = element as? [Any] {
                
                dataSource.setDataSourceData(data)
                dataSource.setDataSourceTable(table)
                
            }
        })
        
    }
    
    func customiseRow2 (cellIdentifier: String,
                       cellType: Any.Type,
                       cellHeight: CGFloat,
                       customise: @escaping (Any, UITableViewCell) -> ()) -> Observable {
        
        return self.do(onNext: { (element) in
          
            if let source = element as? RxDataSource2 {
                
                let row = RxDataRow(cellIdentifier: cellIdentifier,
                                    cellHeight: cellHeight,
                                    customise: customise)
                
                let key = "\(cellType)"
                source.addToKey(key: key, row: row)
                
            }
            
        })
        
//        return Observable<RxDataSource>.create({ (subscriber) -> Disposable in
//            
//            self.subscribe(onNext: { (element) in
//                
//                if let source = element as? RxDataSource {
//                    
//                    let row = RxDataRow(cellIdentifier: cellIdentifier,
//                                        cellHeight: cellHeight,
//                                        customise: customise)
//                    
//                    let key = "\(cellType)"
//                    source.addToKey(key: key, row: row)
//
//                    subscriber.onNext(source)
//                    subscriber.onCompleted()
//                    
//                }
//                
//            }).addDisposableTo(RxDataSourceStore.sharedInstance.disposeBag)
//            
//            return Disposables.create()
//        })
    }
    
}
