//
//  RootViewController.swift
//  SimpleCustomTabBar
//
//  Created by Mike Mikina on 3/26/16.
//  Copyright © 2016 FDT. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UINavigationControllerDelegate {
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.delegate = self
  }
  
  func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
    NSNotificationCenter.defaultCenter().postNotificationName("PageHasStartedTransition", object: viewController, userInfo: nil)
  }
}
