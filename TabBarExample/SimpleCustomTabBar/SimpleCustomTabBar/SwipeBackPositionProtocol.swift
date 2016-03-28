//
//  SwipeBackPositionProtocol.swift
//  SimpleCustomTabBar
//
//  Created by Mike Mikina on 3/28/16.
//  Copyright © 2016 FDT. All rights reserved.
//

import UIKit

protocol SwipeBackPositionProtocol {
  var positionClosure: ((position: Int)->())? {get set}
}