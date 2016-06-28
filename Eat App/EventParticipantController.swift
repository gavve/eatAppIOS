//
//  EventParticipantController.swift
//  Eat App
//
//  Created by vmware on 22/06/16.
//  Copyright © 2016 LiU. All rights reserved.
//
import Foundation
import UIKit

class EventParticipantController: UITableViewController {
    
    var cellIdentifier = "participantCell"
    var event: Event!
    
    @IBOutlet var mytableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // gor annat efter setup
        for id in (self.event.participants) {
            
            UserManager.thisManager.asyncUserByID(id as! Int) { (result2, error) in
                if let result2 = result2 {
                    // Skapar ny användare
                    let par = UserManager.thisManager.parseUserJSON(result2 as! NSDictionary)
                    UserManager.thisManager.addUser(par)
                    self.event!.userParticipants.append(par)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        // laddar om participant tableview efter att anvandardatan har hamtats
                        self.tableView.reloadData()
                        
                    })
                } else {
                    // handle error
                    print("EventDetailVC hamtning av deltagare FAIL")
                }
                
            }
        } // slut for=loop
        
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
        return self.event.userParticipants.count
    }
    
    // skapar vardera cell(rad) i tabellen
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ParticipantTableViewCell
        let user = self.event.userParticipants[indexPath.row]
        
        cell.participantName.text = user.first_name as String
        cell.participantAge.text = String(user.getAge())
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        //TODO: ladda en ny view med specifika detaljer for den valda deltagaren
        
    }
}
