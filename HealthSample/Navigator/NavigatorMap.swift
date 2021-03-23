//
//  Navigator.swift
//  HealthSample
//
//  Created by Feng Yangching on 2020/12/17.
//

import Foundation
import URLNavigator
import RxCocoa

struct MyContext {
    var data: BehaviorRelay<Bool>
    var user: User?
}

class NavigatorMap {
  static func initialize(navigator: NavigatorType) {
    mapLogin(navigator: navigator)
    mapTabbar(navigator: navigator)
   // navigator.register("myapp://user/<int:id>") {}
  }

  static func mapLogin(navigator: NavigatorType) {
  
  }

  static func mapTabbar(navigator: NavigatorType) {
    navigator.register("myapp://tabbarview/<int:index>") { (url, values, _) -> UIViewController? in

      let vc = TabBarVC(navigator: navigator)
      if let index = values["index"] as? Int {
        vc.selectedIndex = index
      }
      return vc
    }

    navigator.register("myapp://user") { (url, values, _) -> UIViewController? in
      let vc = UserVC(navigator: navigator)
      let nvc = UINavigationController.init(rootViewController: vc)
      return nvc
    }

    navigator.register("myapp://steprecord") { (url, values, context) -> UIViewController? in
        guard let user = context as? User else {
            return nil
        }
        let vc = StepRecordVC(navigator: navigator, user: user)
      return vc
    }

    navigator.register("myapp://adduser") { (url, values, context) -> UIViewController? in
        guard let _context = context as? MyContext else {
            return nil
        }
        let vc = AddUserVC(navigator: navigator, completionHandler: _context)
        vc.modalPresentationStyle = UIModalPresentationStyle.custom
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
      return vc
    }
    
    navigator.register("myapp://addstepcounting") { (url, values, context) -> UIViewController? in
        guard let _context = context as? MyContext,
              let user = _context.user else {
            return nil
        }
        let vc = AddStepVC(navigator: navigator,
                           completionHandler: _context,
                           user: user)
        vc.modalPresentationStyle = UIModalPresentationStyle.custom
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
      return vc
    }
    
    navigator.handle("navigator://alert", self.alert(navigator: navigator))

    navigator.handle("navigator://checkalert", self.checkAlert(navigator: navigator))
  }

  private static func alert(navigator: NavigatorType) -> URLOpenHandlerFactory {
    return { url, values, context in
      guard let title = url.queryParameters["title"] else { return false }
      let message = url.queryParameters["message"]
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      navigator.present(alertController)
      return true
    }
  }

  private static func checkAlert(navigator: NavigatorType) -> URLOpenHandlerFactory {
    return { url, values, context in
      guard let title = url.queryParameters["title"] else { return false }
      let message = url.queryParameters["message"]
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "修改", style: .default, handler: nil))
      alertController.addAction(UIAlertAction(title: "確認送出", style: .default, handler: nil))

      navigator.present(alertController)
      return true
    }
  }
}
