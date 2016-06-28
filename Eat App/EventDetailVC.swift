//
//  SecondViewController.swift
//  Eat App
//
//  Created by vmware on 03/06/16.
//  Copyright © 2016 LiU. All rights reserved.
//

import UIKit

class EventDetailVC: UIViewController {
    
    // Mark: Properties
    @IBOutlet weak var hostImage: UIImageView!
    @IBOutlet weak var hostNameandAge: UILabel!
    @IBOutlet weak var labelDistance: UILabel!
    @IBOutlet var currentViewController: UIView!

    var participantString: String = ""
    
    var event: Event! // vi vet att vi far event fran tableview
    var host: User! // hosten hamtas i viewDidLoad med async om inte anv redan finns lagrad

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // Startar async for att hamta forst Hosten och sedan deltagarna
        UserManager.thisManager.asyncUserByID((self.event.userID)) { (result1, error) in
            if let result1 = result1 {
                // process result1
                self.host = UserManager.thisManager.parseUserJSON(result1 as! NSDictionary)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.hostNameandAge.text = (self.host.first_name as String) + " , " + String(self.host.getAge())
                    // TODO: Satt data for host och sedan lagg till en result2 som i loginview for att ocksa hamta deltagarna i bakgrunden och sedan slanga in dom i sin view
                })
                
                
                let url = NSURL(string: self.host.profile_pic_url as String)
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                    dispatch_async(dispatch_get_main_queue(), {
                        self.hostImage.image = UIImage(data: data!)
                    });
                }
            } else {
                // handle error (kanske lagga in ett exempelevent eller nat)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Forbereder segue till containerviews
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "embededSegue") {
            let infoVC = segue.destinationViewController as! EventInfoVC
            // Now you have a pointer to the child view controller.
            // You can save the reference to it, or pass data to it.
            infoVC.event = event
        }
        
    }
    
    
}

