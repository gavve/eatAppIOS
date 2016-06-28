//
//  Event.swift
//  Eat App
//
//  Created by vmware on 15/06/16.
//  Copyright © 2016 LiU. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var priceTag: UILabel!
    @IBOutlet weak var distanceTag: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var dateStart: UILabel!
    @IBOutlet weak var numOfPeople: UILabel!
    @IBOutlet weak var iconDate: UIImageView!

    @IBOutlet weak var iconParticipants: UIImageView!
    @IBOutlet weak var iconDistance: UIImageView!
}
