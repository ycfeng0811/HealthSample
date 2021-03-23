//
//  StepRecordVC.swift
//  HealthSample
//
//  Created by Feng Yangching on 2020/12/17.
//

import Foundation
import UIKit
import URLNavigator
import RxSwift
import RxCocoa
class StepRecordVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let navigator: NavigatorType
    var viewModel: StepRecordVM
    var bag = DisposeBag()
    var updateStepRecords = BehaviorRelay<Bool>(value: true)
    init(navigator: NavigatorType, user: User) {
      self.navigator = navigator
      self.viewModel = StepRecordVM(user: user)
      
      super.init(nibName: "StepRecordView", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.title = "使用者列表"
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "addStepCounting", style: .plain, target: self, action: #selector(addStepCounting))
        let nib = UINib(nibName: "StepRecordTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "StepRecordTableViewCell")
        let output = viewModel.transform(input: StepRecordVM.Input(updateStepRecords: updateStepRecords ))
        
        output.stepRecords
            .drive(tableView.rx.items) { [unowned self] (tableView, row, stepRecord) in
                return self.configTableViewCell(tableView: tableView, row: row, stepRecord: stepRecord)
              }
              .disposed(by: bag)
    }
    
    func configTableViewCell(tableView: UITableView, row: Int, stepRecord: StepRecord) -> UITableViewCell {
        
        let indexPath = IndexPath(row: row, section: 0)
        let cell = tableView.dequeueReusableCell(withIdentifier: "StepRecordTableViewCell", for: indexPath) as! StepRecordTableViewCell
        
        cell.dateLabel.text = stepRecord.date
        cell.stepCounting.text = "\(stepRecord.count)"
        
        return cell
    }
    
    @objc func addStepCounting() {
        let myContext = MyContext(data: updateStepRecords,
                                  user: self.viewModel.user)
       navigator.present("myapp://addstepcounting",
                         context: myContext,
                         wrap: nil,
                         from: nil,
                         animated: false,
                         completion: nil)

    }
}
