//
//  ViewController.swift
//  HealthSample
//
//  Created by Feng Yangching on 2020/12/14.
//

import UIKit
import URLNavigator

struct Items {
  var url: String
  var title: String
  var tag: Int
  var image: UIImage?
  var selectedImage: UIImage?
}

class DefaultItems {
  static var items: [Items] = [
  Items(url: "myapp://user",
        title: LanguageManager.languageText.egc,
        tag: 0,
        image: UIImage(named: "user_off"),
        selectedImage: UIImage(named: "user_on")),
  Items(url: "myapp://steprecord",
        title: "每日步數",
        tag: 1,
        image: UIImage(named: "StepRecord_off"),
        selectedImage: UIImage(named: "StepRecord_on"))]
}

class TabBarVC: UITabBarController {
    
    var navigator: NavigatorType
    let itemAttributes: [Items] = [DefaultItems.items[0],
                                   DefaultItems.items[1]]
    
    init(navigator: NavigatorType) {
      self.navigator = navigator
      super.init(nibName: "TabBarView", bundle: nil)
      self.configItems()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
          let appearance = UITabBarAppearance()
          appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black.cgColor]
          tabBar.standardAppearance = appearance
        } else {
          let appearance = UITabBarItem.appearance(whenContainedInInstancesOf: [TabBarVC.self])
          appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black.cgColor], for: .normal)
          appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black.cgColor], for: .selected)
        }
    }

    
    func configItems() {
      let items: [Items] = itemAttributes
      var vcs = [UIViewController]()
      for itemAttr in items {
        guard let vc = navigator.viewController(for: itemAttr.url) else {
          break
        }
        vc.tabBarItem = UITabBarItem.init(title: itemAttr.title, image: itemAttr.image, tag: itemAttr.tag)
        vc.tabBarItem.selectedImage = itemAttr.selectedImage
        vcs.append(vc)
      }
      self.viewControllers = vcs
    }

}

