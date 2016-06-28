//
//  EventManager.swift
//  Eat App
//
//  Created by vmware on 13/06/16.
//  Copyright © 2016 LiU. All rights reserved.
//


import Foundation

public class Event: NSObject
{
    // Attribut för eventet
    var id : Int = 0
    var title: NSString = ""
    var desc: NSString = ""
    var numOfPeople: Int = 0
    var date_start: String = ""
    var date_created: String = ""
    var date_updated: String = ""
    var price: Float = 0.0
    var participants: NSMutableArray = []
    var userID: Int = 0
    
    // Attribut participants i app
    var userParticipants = [User]()
    
    
    // Distans & Location
    var distance: Float = 0.0
    var long: Float = 0.0
    var lat: Float = 0.0
    
    override init() {
        // Gör saker när instansering sker
    }
    
    // MARK: Methods
    func convertDate(date:String) -> NSDate{
        // konverterar datum fran API till NSDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let d = dateFormatter.dateFromString(date)
        return d!
    }
    
    // formaterar distans till event
    func getDistance() -> String {
        var distString = "< 0.5 km"
        if self.distance > 0.5 {
            distString = String(format: "%.1f km", self.distance)
        }
        return distString
    }
    
    // Formaterar deltagare/totalt antal deltagare
    func howManyParticipants() -> String {
        let s = String(format: "%i / %i", self.participants.count, self.numOfPeople)
        return s
    }
}

extension NSDate {
    // extension for att kunna formatera datum lite som jag vill i appen
    convenience init(dateString: String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        dateStringFormatter.timeZone = NSTimeZone(name: "GMT")
        let date = dateStringFormatter.dateFromString(dateString)
        
        self.init(timeInterval:0, sinceDate:date!)
    }
    
    func getDatePart() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd MMM"
        formatter.timeZone = NSTimeZone(name: "GMT")
        
        return formatter.stringFromDate(self)
    }
    
    func getTimePart() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = NSTimeZone(name: "GMT")
        
        return formatter.stringFromDate(self)
    }
}


class EventManager {
    // Singleton Instans för att hantera alla events
    static let thisManager = EventManager();
    
    // Attribut
    var events = [Event]()
    
    private init() {}
    
    
    // Metoder, lagg till, ta bort och hamta event med specifik ID
    func addEvent(e:Event) {
        self.events.append(e)
    }
    
    func getEventWithID(id:Int) -> Any? {
        for e in self.events {
            if e.id == id {
                return e
            }
        }
        return nil
    }
    
    func createEvent() {
        print("creating event")
    }
    
    
    func asyncRetrieveEventsCloseBy(radius: Float, completion: (AnyObject?, ErrorType?)->()) {
        // Thread arbete till API
        let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        var dataTask: NSURLSessionDataTask?
            
            let user = SessionUser.thisInstance
            let id = String(user.id)
            let lat = String(user.latitude)
            let long = String(user.longitude)
            print("anvandarid"+id)
            let eventPrefix = "/events/?pk="+id+"&long="+long+"&lat="+lat
            
            let request = NSMutableURLRequest(URL: NSURL(string: AppManager.thisInstance.baseURL + eventPrefix)!)
            request.setValue("Bearer \(user.access_token as String)", forHTTPHeaderField: "Authorization")
            
            
            // 6
            dataTask = defaultSession.dataTaskWithRequest(request) {data, response, error in
                
                // 8
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil, error)
                } else if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        
                        do {
                            let NSJSONDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                            completion(NSJSONDict, nil)
                            
                        } catch let error as NSError {
                            print("Json error: \(error.localizedDescription)")
                            completion(nil, error)
                        }
                        
                    } else {
                        completion(nil, error)
                    }
                }
                
            } // end DataTask
            // 9
            dataTask?.resume()
        }
        
    
    func showError() {
        print("Error when retrieveng events")
    }
    
    func parseEventJSON(dic: NSDictionary) {
        let result = dic["results"] as! NSArray
        
        for item in result {
            let event = item as! NSDictionary
            let newEvent: Event = Event()
            newEvent.id = event["pk"] as! Int
            newEvent.desc = event["description"] as! String
            newEvent.title = event["title"] as! String
            newEvent.date_start = event["date_start"] as! String
            newEvent.date_created = event["date_created"] as! String
            newEvent.date_updated = event["date_updated"] as! String
            newEvent.distance = event["distance"] as! Float
            newEvent.lat = event["location"]!["latitude"] as! Float
            newEvent.long = event["location"]!["longitude"] as! Float
            newEvent.price = event["price"] as! Float
            newEvent.userID = event["user"] as! Int
            newEvent.numOfPeople = event["numOfPeople"] as! Int
            
            // spararer endast en array med ID pa deltagarna for eventet
            for part in event["participant"] as! NSArray {
                newEvent.participants.addObject(part["pk"] as! Int)
            }
            
            // Avsluta med att spara eventet
            self.addEvent(newEvent)
            print(item)
        }
        
        
    }
    
}