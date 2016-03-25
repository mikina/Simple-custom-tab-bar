//
//  SimpleCustomTabBarSegue.swift
//  SimpleCustomTabBar
//
//  Created by Mike Mikina on 3/23/16.
//  Copyright © 2016 FDT. All rights reserved.
//

import UIKit

class SimpleCustomTabBarSegue: UIStoryboardSegue {
  
  override func perform() {
    guard let tabVC: SimpleCustomTabBarController = self.sourceViewController as? SimpleCustomTabBarController else {
      return
    }
    guard let destinationVC: UIViewController = tabVC.destinationVC else {
      return
    }
    
    if let oldVC = tabVC.previousVC {
      oldVC.willMoveToParentViewController(nil)
      oldVC.view.removeFromSuperview()
      oldVC.removeFromParentViewController()
    }
    
    destinationVC.view.frame = tabVC.container.bounds
    tabVC.addChildViewController(destinationVC)
    tabVC.container.addSubview(destinationVC.view)
    destinationVC.didMoveToParentViewController(tabVC)
  }
}
