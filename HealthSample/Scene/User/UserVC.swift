//
//  UserVC.swift
//  HealthSample
//
//  Created by Feng Yangching on 2020/12/16.
//

import Foundation
import UIKit
import URLNavigator
import RxSwift
import RxCocoa

class UserVC: UIViewController {

    
    let navigator: NavigatorType
    let viewModel: UserVM
    var bag = DisposeBag()
    var updateUser = BehaviorRelay<Bool>.init(value: true)
    var selectedUser: User?
 
    @IBOutlet weak var tableView: UITableView!
    init(navigator: NavigatorType) {
      self.navigator = navigator
        viewModel = UserVM.init()
      super.init(nibName: "UserView", bundle: nil)
     
    }

    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "使用者列表"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addUser))
        
        let nib = UINib(nibName: "UserTableviewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UserTableviewCell")
        
        let output = viewModel.transform(input: UserVM.Input.init(updateUsers: updateUser))
        viewModelOutputConfig(output: output)
        
        tableView
            .rx
            .itemDeleted
            .subscribe(onNext: { [unowned self] (indexPath) in
                DBService
                    .UserTable
                    .delete(user: self.viewModel.users.value[indexPath.row])
                self.updateUser.accept(true)
            }).disposed(by: bag)
        
        tableView
            .rx
            .itemSelected
            .subscribe { [unowned self] (indexPath) in
                guard let _indexPath = indexPath.element, let cell = self.tableView.cellForRow(at: _indexPath) as? UserTableviewCell else {
                    return
                }
                cell.checkImage.isHidden = !cell.checkImage.isHidden
            }.disposed(by: bag)
        


    }
    
    @objc private func addUser() {
        let myContext = MyContext(data: updateUser)
       navigator.present("myapp://adduser", context: myContext, wrap: nil, from: nil, animated: false, completion: nil)

       
    }
    
    func viewModelOutputConfig(output: UserVM.Output) {
        output.users
            .drive(tableView.rx.items) { [unowned self] (tableView, row, user) in
                return self.configTableViewCell(tableView: tableView, row: row, user: user)
              }
              .disposed(by: bag)
    }
    
    func configTableViewCell(tableView: UITableView, row: Int, user: User) -> UITableViewCell {
        
        let indexPath = IndexPath(row: row, section: 0)
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableviewCell", for: indexPath) as! UserTableviewCell
        
        cell.titleLabel.text = "姓名: " + user.name
        cell.birthdayLabel.text = "生日: " + user.birthday
        cell.user = user
        cell.stepRecordButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                self?.navigator.push("myapp://steprecord",
                                     context: user,
                                     from: nil,
                                     animated: true)
            })
            .disposed(by: cell.bag)
        return cell
    }
    
}
