//
//  StepRecordTableViewCellVC.swift
//  HealthSample
//
//  Created by Feng Yangching on 2020/12/22.
//

import Foundation
import UIKit
import RxSwift

class StepRecordTableViewCell: UITableViewCell {
    var user: User?
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var stepCounting: UILabel!
    
    var bag = DisposeBag()

    override func prepareForReuse() {
      super.prepareForReuse()
     
    }

    override func awakeFromNib() {
      super.awakeFromNib()
        
    }
}
