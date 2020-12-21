//
//  UserTableviewCellVC.swift
//  HealthSample
//
//  Created by Feng Yangching on 2020/12/18.
//

import Foundation
import UIKit
import RxSwift
class UserTableviewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    
    var disposeBag = DisposeBag()

    override func prepareForReuse() {
      super.prepareForReuse()
     
    }

    override func awakeFromNib() {
      super.awakeFromNib()
      
    }
}
