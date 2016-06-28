//
//  EventDescriptionController.swift
//  Eat App
//
//  Created by vmware on 22/06/16.
//  Copyright © 2016 LiU. All rights reserved.
//

import UIKit

class EventDescriptionController: UIViewController {
    // Atttribut
    @IBOutlet weak var descriptionField: UITextView!
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // andra saker
        self.descriptionField.text = self.event.desc as String
    }
}
