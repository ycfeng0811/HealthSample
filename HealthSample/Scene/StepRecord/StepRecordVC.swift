//
//  StepRecordVC.swift
//  HealthSample
//
//  Created by Feng Yangching on 2020/12/17.
//

import Foundation
import UIKit
import URLNavigator

class StepRecordVC: UIViewController {
    
    let navigator: NavigatorType

    init(navigator: NavigatorType) {
      self.navigator = navigator
      super.init(nibName: "StepRecordView", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
