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
 
    @IBOutlet weak var tableview: UITableView!
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addUser))
        
        let nib = UINib(nibName: "UserTableviewCell", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: "UserTableviewCell")
        
        let output = viewModel.transform(input: UserVM.Input.init(updateUsers: updateUser))
        viewModelOutputConfig(output: output)
        tableview
            .rx
            .itemDeleted
            .subscribe(onNext: { [unowned self] (indexPath) in
                DBService
                    .UserTable
                    .delete(user: self.viewModel.users.value[indexPath.row])
                self.updateUser.accept(true)
            }).disposed(by: bag)
        
    }
    
    @objc private func addUser() {
        let myContext = MyContext(data: updateUser)
       navigator.present("myapp://adduser", context: myContext, wrap: nil, from: nil, animated: false, completion: nil)

       
    }
    
    func viewModelOutputConfig(output: UserVM.Output) {
        output.users
            .drive(tableview.rx.items) { [unowned self] (tableview, row, user) in
                return self.configTableViewCell(tableview: tableview, row: row, user: user)
              }
              .disposed(by: bag)
    }
    
    func configTableViewCell(tableview: UITableView, row: Int, user: User) -> UITableViewCell {
        
        let indexPath = IndexPath(row: row, section: 0)
        let cell = tableview.dequeueReusableCell(withIdentifier: "UserTableviewCell", for: indexPath) as! UserTableviewCell
        
        cell.titleLabel.text = "姓名: " + user.name
        cell.birthdayLabel.text = "生日: " + user.birthday
    
        return cell
    }
    
}
