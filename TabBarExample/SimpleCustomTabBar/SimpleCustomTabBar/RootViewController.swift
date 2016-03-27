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
    // We send notification when transition is started, it's possible to cancel transition when
    // user just start swipe back and cancel it. In this case tab bar will be shown when it's not suppose to.
    // It's possible to check in transition coordinator if swipe back is not canceled.
    if let coordinator = navigationController.topViewController?.transitionCoordinator() {
      coordinator.notifyWhenInteractionEndsUsingBlock({ (context) in
        if context.isCancelled() {
          NSNotificationCenter.defaultCenter().postNotificationName(kPageHasStartedTransition, object: self, userInfo: nil)
        }
      })
    }
    NSNotificationCenter.defaultCenter().postNotificationName(kPageHasStartedTransition, object: viewController, userInfo: nil)
  }
}
