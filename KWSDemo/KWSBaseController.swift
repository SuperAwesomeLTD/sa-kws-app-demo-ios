//
//  KWSBaseController.swift
//  KWSDemo
//
//  Created by Gabriel Coman on 08/12/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class KWSBaseController: UIViewController, KWSPopupNavigationBarProtocol {

    // the dispose bag object
    let disposeBag = DisposeBag ()
    private var onSegue: ((_ destination: UIViewController) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bar = navigationController?.navigationBar as? KWSPopupNavigationBar {
            bar.kwsdelegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func performSegue(withIdentifier identifier: String, sender: Any?, onSegue: @escaping (_ destiantion: UIViewController) -> Void) {
        self.onSegue = onSegue
        self.performSegue(withIdentifier: identifier, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let seg = onSegue {
            seg(segue.destination)
        }
    }
    
    func rxSeque(withIdentifier identifier: String) -> Observable<UIViewController> {
        return Observable.create({ (observable) -> Disposable in
            
            self.performSegue(withIdentifier: identifier, sender: self, onSegue: { (destination) in
                
                observable.onNext(destination)
                observable.onCompleted()
                
            })
            
            return Disposables.create()
        })
    }
    
    func kwsPopupNavDidPressOnClose() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        for view : UIView in self.view.subviews {
            if let view = view as? UITextField {
                view.resignFirstResponder()
            }
        }
    }

}
