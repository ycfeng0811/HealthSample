//
//  AddUserVC.swift
//  HealthSample
//
//  Created by Feng Yangching on 2020/12/17.
//

import Foundation
import URLNavigator
import UIKit
import RxSwift
import RxCocoa

class AddUserVC: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addUserButton: UIButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var birthday: UITextField!
    let navigator: NavigatorType
    let viewModel: AddUserVM
    let bag = DisposeBag()
    var _completionHandler: MyContext?
    init(navigator: NavigatorType, completionHandler: MyContext) {
      self.navigator = navigator
      self._completionHandler = completionHandler
      viewModel = AddUserVM.init()
      super.init(nibName: "AddUserView", bundle: nil)
     
    }

    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let output =  viewModel.transform(input: AddUserVM.Input(name: self.name.rx.text,
                                                   birthday: self.birthday.rx.text,
                                                   addUser: self.addUserButton.rx.tap))
        output.isDismiss
            .filter{ $0 }
            .subscribe { _ in
                self.dismiss(animated: true, completion: {
                    self._completionHandler?.data.accept(true)
                })
            }.disposed(by: bag)
        
        output.isEmpty
            .subscribe { isEmpty in
                self.navigator.open("navigator://alert?title=請輸入姓名跟生日")
            }.disposed(by: bag)


        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)

    }
    
    @objc func cancel() {
        self.dismiss(animated: false) 
    }
    
}
