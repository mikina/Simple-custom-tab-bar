//
//  RootViewController.swift
//  SimpleCustomTabBar
//
//  Created by Mike Mikina on 3/26/16.
//  Copyright © 2016 FDT. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate, SwipeBackPositionProtocol {
  var positionClosure: ((position: Int)->())?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.delegate = self
    self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    self.navigationController?.interactivePopGestureRecognizer?.addTarget(self, action: #selector(RootViewController.test(_:)))
  }
  
  func test(gesture: UIPanGestureRecognizer) {
    if let position = self.positionClosure, let gestureView = gesture.view {
      let translation = gesture.translationInView(gestureView)
      position(position: Int(translation.x))
    }
  }
  
  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
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
  
  func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
    NSNotificationCenter.defaultCenter().postNotificationName(kPageHasStartedTransition, object: viewController, userInfo: nil)
  }
}
