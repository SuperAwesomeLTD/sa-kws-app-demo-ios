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

class RxDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {

    var key: Int
    var table: UITableView?
    var data: [Any] = []
    fileprivate var viewModelToRxRow: [String : RxDataRow] = [:]
    
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
        //
    }
    
    func update () -> Void {
        
        table?.delegate = self
        table?.dataSource = self
        
        Observable
            .from(data)
            .filter { (element) -> Bool in
                let key = "\(type(of: element))"
                return self.viewModelToRxRow[key] != nil
            }
            .toArray()
            .subscribe(onNext: { (newData: [Any]) in
                
                self.data = newData
                self.table?.reloadData()
                
            })
            .addDisposableTo(RxDataSourceStore.sharedInstance.disposeBag)
    }
}

private struct RxDataRow {
    public var cellIdentifier: String
    public var cellHeight: CGFloat
    public var customise: ((Any, UITableViewCell) -> ())
}

class RxDataSourceStore {
    var disposeBag = DisposeBag ()
    var dataSources: [Int : RxDataSource] = [:]
    static let sharedInstance = RxDataSourceStore()
    private init() {}
}

extension Observable {
    
    func bindTable (_ table: UITableView) -> Observable <RxDataSource> {
        
        return Observable<RxDataSource>.create({ (subscriber) -> Disposable in
            
            let key = SAUtils.randomNumberBetween(1000, maxNumber: 2500)
            let dataSource = RxDataSource (key: key)
            
            self.subscribe(onNext: { (element) in
                
                if let data = element as? [Any] {
                    dataSource.setDataSourceTable(table)
                    dataSource.setDataSourceData(data)
                    subscriber.onNext(dataSource)
                    subscriber.onCompleted()
                    
                    // add data source to store
                    RxDataSourceStore.sharedInstance.dataSources[key] = dataSource
                }
                
            })
            .addDisposableTo(RxDataSourceStore.sharedInstance.disposeBag)
            
            return Disposables.create()
        })
        
    }
    
    func customiseRow (cellIdentifier: String,
                       cellType: Any.Type,
                       cellHeight: CGFloat,
                       customise: @escaping (Any, UITableViewCell) -> ()) -> Observable <RxDataSource> {
        
        return Observable<RxDataSource>.create({ (subscriber) -> Disposable in
            
            self.subscribe(onNext: { (element) in
              
                if let source = element as? RxDataSource {
                    
                    let row = RxDataRow(cellIdentifier: cellIdentifier,
                                        cellHeight: cellHeight,
                                        customise: customise)

                    let key = "\(cellType)"
                    source.addToKey(key: key, row: row)
                    
                    subscriber.onNext(source)
                    subscriber.onCompleted()
                    
                }
                
            }).addDisposableTo(RxDataSourceStore.sharedInstance.disposeBag)
            
            return Disposables.create()
        })
    }
    
    func update () -> Disposable {
        
        return Observable<RxDataSource>.create({ (subscriber) -> Disposable in
            
            self.subscribe(onNext: { (element) in
                
                if let source = element as? RxDataSource {
                    subscriber.onNext(source)
                    subscriber.onCompleted()
                }
            }).addDisposableTo(RxDataSourceStore.sharedInstance.disposeBag)
            
            return Disposables.create()
        }).subscribe(onNext: { (dataSource) in
            dataSource.update()
        })
        
    }
    
}
