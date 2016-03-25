//
//  SimpleCustomTabBarController.swift
//  SimpleCustomTabBar
//
//  Created by Mike Mikina on 3/23/16.
//  Copyright © 2016 FDT. All rights reserved.
//

import UIKit

class SimpleCustomTabBarController: UIViewController {

  var viewControllersCache: NSMutableDictionary?
  var destinationIdentifier: String?
  weak var destinationVC: UIViewController?
  var previousVC: UIViewController?
  @IBOutlet weak var container: UIView!
  @IBOutlet var tabButtons: [UIButton]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.viewControllersCache = NSMutableDictionary();
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
}