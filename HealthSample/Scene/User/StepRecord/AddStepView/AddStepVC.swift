//
//  AddStepVC.swift
//  HealthSample
//
//  Created by Feng Yangching on 2020/12/21.
//

import Foundation
import URLNavigator
import RxCocoa
import RxSwift

class AddStepVC: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var countTextField: UITextField!
    let navigator: NavigatorType
    let viewModel: AddStepVM
    let bag = DisposeBag()
    var _completionHandler: MyContext?
    init(navigator: NavigatorType, completionHandler: MyContext, user: User) {
      self.navigator = navigator
      self._completionHandler = completionHandler
        viewModel = AddStepVM.init(user: user)
      super.init(nibName: "AddStepView", bundle: nil)
     
    }

    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        let output =  viewModel.transform(input: AddStepVM.Input.init(count: countTextField.rx.text.orEmpty, date: dateTextField.rx.text, addStepRecord: addButton.rx.tap))
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
