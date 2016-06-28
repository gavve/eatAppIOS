//
//  EventInfoVC.swift
//  Eat App
//
//  Created by vmware on 23/06/16.
//  Copyright © 2016 LiU. All rights reserved.
//

import UIKit

class EventInfoVC: UIViewController {
    
    @IBOutlet weak var participantView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var descView: UIView!
    
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // andra initialiseringar
        self.descView.alpha = 1
        self.participantView.alpha = 0
    }
    
    // Andrar vilken view som ska synas under segmentControl
    @IBAction func switchSegmentView(sender: AnyObject) {
    switch segmentControl.selectedSegmentIndex
        {
        case 0:
            UIView.animateWithDuration(0.5, animations: {
                self.descView.alpha = 1
                self.participantView.alpha = 0
            })
        case 1:
            UIView.animateWithDuration(0.5, animations: {
                print(self.participantView.subviews.description)
                self.descView.alpha = 0
                self.participantView.alpha = 1
            })
        default:
            UIView.animateWithDuration(0.5, animations: {
                self.descView.alpha = 1
                self.participantView.alpha = 0
            })
    }
    }
    
    // Forbereder segue till containerviews
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "beskrivningSegue") {
            let descVC = segue.destinationViewController as! EventDescriptionController
            // Now you have a pointer to the child view controller.
            // You can save the reference to it, or pass data to it.
            descVC.event = event
        }
        
        if (segue.identifier == "deltagareSegue") {
            let partVC = segue.destinationViewController as! EventParticipantController
            // Now you have a pointer to the child view controller.
            // You can save the reference to it, or pass data to it.
            partVC.event = event
        }
    }
}
