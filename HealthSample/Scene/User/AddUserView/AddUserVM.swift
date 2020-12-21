//
//  AddUserVM.swift
//  HealthSample
//
//  Created by Feng Yangching on 2020/12/18.
//

import Foundation
import RxSwift
import RxCocoa

class AddUserVM: ModelViewViewModel {
    
    let bag = DisposeBag()
    var isEmpty: PublishRelay<Bool> = PublishRelay<Bool>.init()
    var isDismiss: BehaviorRelay<Bool> = BehaviorRelay<Bool>.init(value: false)
    var user: User?
    
    struct Input {
        var name: ControlProperty<String?>
        var birthday: ControlProperty<String?>
        var addUser: ControlEvent<()>
    }

    struct Output {
        var isEmpty: PublishRelay<Bool>
        var isDismiss: BehaviorRelay<Bool>
    }

    func transform(input: AddUserVM.Input) -> AddUserVM.Output {
        
        Observable.combineLatest(input.name, input.birthday)
            .skip(1)
            .subscribe { (name, birthday) in
                guard let _name = name, let _birthday = birthday else {
                    return
                }
                if _name != "" && _birthday != "" {
                    self.user = User(name: _name, birthday: _birthday)
                }
              
            }.disposed(by: bag)

        input.addUser
            .subscribe { _ in
                guard let _user = self.user else {
                    self.isEmpty.accept(true)
                    return
                }
                DBService.UserTable.insert(user: _user)
                self.isDismiss.accept(true)
            }.disposed(by: bag)

        
            
        return Output.init(isEmpty: self.isEmpty, isDismiss: self.isDismiss)
    }
    
}
