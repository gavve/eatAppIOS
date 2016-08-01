//
//  ParticipantTableViewCell.swift
//  Eat App
//
//  Created by vmware on 22/06/16.
//  Copyright © 2016 LiU. All rights reserved.
//

import UIKit

class ParticipantTableViewCell: UITableViewCell {
    
    // MARK: Properties

    @IBOutlet weak var participantName: UILabel!
    @IBOutlet weak var participantAge: UILabel!
    var user: User?
    
}