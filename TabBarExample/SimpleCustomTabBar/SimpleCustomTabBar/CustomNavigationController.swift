//
//  CustomNavigationController.swift
//  SimpleCustomTabBar
//
//  Created by Mike Mikina on 3/28/16.
//  Copyright © 2016 FDT. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate, SwipeBackPositionProtocol {
  var positionClosure: ((position: Int)->())?
  var duringPushAnimation = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    self.interactivePopGestureRecognizer?.delegate = self
    self.interactivePopGestureRecognizer?.addTarget(self, action: #selector(CustomNavigationController.backAction(_:)))
  }

  func backAction(gesture: UIPanGestureRecognizer) {
    if let position = self.positionClosure, let gestureView = gesture.view {
      let translation = gesture.translationInView(gestureView)
      position(position: Int(translation.x))
    }
  }

  func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
  // When interactivePopGestureRecognizer delegate is set, we need to check if
  // navigation controller has more than one vc. If not don't perform edge pan back gesture.
  func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
    if gestureRecognizer.isKindOfClass(UIScreenEdgePanGestureRecognizer.self)
        && self.viewControllers.count == 1 {
      return false
    }
    
    if self.duringPushAnimation {
      return false
    }
    
    return true
  }

  func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
    // We send notification when transition is started, it's possible to cancel transition when
    // user just start swipe back and cancel it. In this case tab bar will be shown when it's not suppose to.
    // It's possible to check in transition coordinator if swipe back is not canceled.
    if let coordinator = navigationController.topViewController?.transitionCoordinator() {
      coordinator.notifyWhenInteractionEndsUsingBlock({ (context) in
        if context.isCancelled() {
          if let position = self.positionClosure {
            position(position: 0)
          }
        }
      })
    }
    NSNotificationCenter.defaultCenter().postNotificationName(kPageHasStartedTransition, object: viewController, userInfo: nil)
  }

  func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
    NSNotificationCenter.defaultCenter().postNotificationName(kPageHasStartedTransition, object: viewController, userInfo: nil)
    self.duringPushAnimation = false
  }
  
  override func pushViewController(viewController: UIViewController, animated: Bool) {
    super.pushViewController(viewController, animated: animated)
    self.duringPushAnimation = true
  }
  
  deinit {
    self.delegate = nil
    self.interactivePopGestureRecognizer?.delegate = nil
  }
}
