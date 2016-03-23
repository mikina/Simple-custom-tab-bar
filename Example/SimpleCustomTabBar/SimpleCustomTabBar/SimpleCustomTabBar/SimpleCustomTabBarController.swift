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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.viewControllersCache = NSMutableDictionary();
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
  }
}
