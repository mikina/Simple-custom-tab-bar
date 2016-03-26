//
//  ModalViewController.swift
//  SimpleCustomTabBar
//
//  Created by Mike Mikina on 3/26/16.
//  Copyright © 2016 FDT. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

  override func viewDidLoad() {
      super.viewDidLoad()
  }
  
  @IBAction func dissmisModal(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}
