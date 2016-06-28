//
//  FirstViewController.swift
//  Eat App
//
//  Created by vmware on 03/06/16.
//  Copyright © 2016 LiU. All rights reserved.
//

import UIKit

class TableViewControllerEvents: UITableViewController {
    
    //  MARK: Properties
    let cellIdentifier = "eventCell"
    var eventsInTable: [Event]?
    var eventSelected: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        EventManager.thisManager.asyncRetrieveEventsCloseBy(50.0) { (result1, error) in
            if let result1 = result1 {
                // process result1
                EventManager.thisManager.parseEventJSON(result1 as! NSDictionary)
                self.eventsInTable = EventManager.thisManager.events
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            } else {
                // handle error (kanske lagga in ett exempelevent eller nat)
            }
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .Plain, target: self, action: "createEventSegue")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Table View methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // returnerar antalet rader som skall finnas med
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventManager.thisManager.events.count
    }
    
    // skapar vardera cell(rad) i tabellen
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! EventTableViewCell
        
        // Fetches the appropriate event for the data source layout.
        let event = eventsInTable![indexPath.row]
        let title = event.title as String
        cell.title.text = title.capitalizingFirstLetter()
        cell.desc.text = event.desc as String
        cell.numOfPeople.text = event.howManyParticipants()
        cell.distanceTag.text = String(event.getDistance())
        cell.dateStart.text = event.date_start as String
        cell.priceTag.text = "€ " + String(event.price)
        cell.dateStart.text = event.convertDate(event.date_start).getDatePart() + "\r" + event.convertDate(event.date_start).getTimePart()
        
        // Icons
        let dateIcon = UIImage(named: "overtime")
        let participantIcon = UIImage(named: "groups")
        let distanceIcon = UIImage(named: "geo_fence")
        
        cell.iconDate.image = dateIcon
        cell.iconParticipants.image = participantIcon
        cell.iconDistance.image = distanceIcon
        
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.lightGrayColor()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.eventSelected = self.eventsInTable![indexPath.row]
        print(self.eventSelected)
        performSegueWithIdentifier("detailEventScreen", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailEventScreen" {
            let svc = segue.destinationViewController as! EventDetailVC
            let e = self.eventSelected
            svc.event = e
            
        }
    }
}

