//
//  SimpleCustomTabBarController.swift
//  SimpleCustomTabBar
//
//  Created by Mike Mikina on 3/23/16.
//  Copyright © 2016 FDT. All rights reserved.
//

import UIKit
let kPageHasStartedTransition = "PageHasStartedTransition"

class SimpleCustomTabBarController: UIViewController {

  var viewControllersCache: NSMutableDictionary?
  var destinationIdentifier: String?
  weak var destinationVC: UIViewController?
  var previousVC: UIViewController?
  var tabBarVisible = true
  let animationDuration = 0.3 //duration of show/hide tab bar animation
  let bottomPosition = 0 //bottom tab bar position, 0 - means it will stick to bottom
  @IBOutlet weak var container: UIView!
  @IBOutlet var tabButtons: [UIButton]!
  @IBOutlet weak var tabBar: UIView!
  @IBOutlet weak var tabBarHeight: NSLayoutConstraint!
  @IBOutlet weak var tabBarBottom: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.viewControllersCache = NSMutableDictionary();
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: #selector(SimpleCustomTabBarController.startedTransition(_:)),
      name: kPageHasStartedTransition,
      object: nil)
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if self.childViewControllers.count < 1 {
      self.performSegueWithIdentifier("vc1", sender: self.tabButtons[0])
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    self.previousVC = self.destinationVC
    
    guard let identifier = segue.identifier else {
      return;
    }
    
    if self.viewControllersCache?.objectForKey(identifier) == nil {
      self.viewControllersCache?.setObject(segue.destinationViewController, forKey: identifier)
    }
    
    self.destinationIdentifier = identifier
    self.destinationVC = self.viewControllersCache?.objectForKey(identifier) as? UIViewController
    
    for button in self.tabButtons {
      button.selected = false
    }
    
    if let button = sender as? UIButton, let index = self.tabButtons.indexOf(button) {
      self.tabButtons[index].selected = true
    }    
  }
  
  override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
    if self.destinationIdentifier == identifier {
      // We want to go back in navigation bar when user hit currently selected tab
      if let nav = self.destinationVC as? UINavigationController {
        nav.popToRootViewControllerAnimated(true)
      }
      return false
    }
    return true
  }
  
  func hideTabBar() {
    self.tabBarBottom.constant = -self.tabBarHeight.constant
    UIView.animateWithDuration(self.animationDuration) {
      self.view.layoutIfNeeded()
    }
  }
  
  func showTabBar() {
    self.tabBarBottom.constant = CGFloat(self.bottomPosition)
    UIView.animateWithDuration(self.animationDuration) {
      self.view.layoutIfNeeded()
    }
  }
  
  func startedTransition(notification: NSNotification) {
    if let item = notification.object as? TabBarVisibilityProtocol {
      if item.isVisible {
        self.showTabBar()
      }
      else {
        self.hideTabBar()
      }
    }
  }
}
