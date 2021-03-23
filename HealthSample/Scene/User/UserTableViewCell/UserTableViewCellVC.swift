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
    @IBOutlet weak var stepRecordButton: UIButton!
    @IBOutlet weak var checkImage: UIImageView!
    var user: User?
    
    var bag = DisposeBag()

    override func prepareForReuse() {
      super.prepareForReuse()
     
    }

    override func awakeFromNib() {
      super.awakeFromNib()
        
    }
    
}
