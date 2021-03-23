//
//  StepRecordVM.swift
//  HealthSample
//
//  Created by Feng Yangching on 2020/12/22.
//

import Foundation
import RxSwift
import RxCocoa

class StepRecordVM: ModelViewViewModel {
    var stepRecords: BehaviorRelay<[StepRecord]> = BehaviorRelay(value: [])
    var bag = DisposeBag()
    var user: User
    init(user: User) {
        self.user = user
    }
    struct Input {
        var updateStepRecords: BehaviorRelay<Bool>
    }

    struct Output {
        var stepRecords: Driver<[StepRecord]>
    }

    func transform(input: StepRecordVM.Input) -> StepRecordVM.Output {
        input.updateStepRecords
            .filter{ $0 }
            .subscribe { _ in
                self.stepRecords.accept(DBService.StepRecordTable.getAllStepRecords())
            }.disposed(by: bag)

            
        return Output.init(stepRecords: stepRecords.asDriver())
    }
    
    
    
}
