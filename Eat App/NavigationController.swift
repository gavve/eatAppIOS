//
//  NavigationController.swift
//  Eat App
//
//  Created by vmware on 21/06/16.
//  Copyright © 2016 LiU. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {
    


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: "EventManager.thisManager.createEvent")
    }
}