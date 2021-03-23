//
//  AddStepVM.swift
//  HealthSample
//
//  Created by Feng Yangching on 2020/12/21.
//

import Foundation
import RxSwift
import RxCocoa

class AddStepVM: ModelViewViewModel {
    
    let bag = DisposeBag()
    var isEmpty: PublishRelay<Bool> = PublishRelay<Bool>.init()
    var isDismiss: BehaviorRelay<Bool> = BehaviorRelay<Bool>.init(value: false)
    var stepRecord: StepRecord?
    var user: User
    
    init(user: User) {
        self.user = user
    }
    
    struct Input {
        var count: ControlProperty<String>
        var date: ControlProperty<String?>
        var addStepRecord: ControlEvent<()>
    }

    struct Output {
        var isEmpty: PublishRelay<Bool>
        var isDismiss: BehaviorRelay<Bool>
    }

    func transform(input: AddStepVM.Input) -> AddStepVM.Output {
        Observable.combineLatest(input.count, input.date)
            .skip(1)
            .subscribe { (count, date) in
                
                guard let _count = Int64(count), let _date = date else {
                    return
                }

                self.stepRecord = StepRecord.init(userID: Int64(self.user.id),
                                                  count: _count,
                                                  date: _date)
                
              
            }.disposed(by: bag)

        input.addStepRecord
            .subscribe { _ in
                guard let _stepRecord = self.stepRecord else {
                    self.isEmpty.accept(true)
                    return
                }
                DBService.StepRecordTable.insert(stepRecord: _stepRecord)
                self.isDismiss.accept(true)
            }.disposed(by: bag)

        
            
        return Output.init(isEmpty: self.isEmpty, isDismiss: self.isDismiss)
    }
    
}

