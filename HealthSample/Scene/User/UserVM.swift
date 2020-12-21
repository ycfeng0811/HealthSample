//
//  UserVM.swift
//  HealthSample
//
//  Created by Feng Yangching on 2020/12/17.
//

import Foundation
import RxSwift
import RxCocoa

class UserVM: ModelViewViewModel {
    
    var users: BehaviorRelay<[User]> = BehaviorRelay(value: [])
    var bag = DisposeBag()
    struct Input {
        var updateUsers: BehaviorRelay<Bool>
    }

    struct Output {
        var users: Driver<[User]>
    }

    func transform(input: UserVM.Input) -> UserVM.Output {
        input.updateUsers
            .filter{ $0 }
            .subscribe { _ in
                self.users.accept(DBService.UserTable.getAllUsers())
            }.disposed(by: bag)

            
        return Output.init(users: users.asDriver())
    }
    
    
}
