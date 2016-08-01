//
//  UserManager.swift
//  Eat App
//
//  Created by vmware on 03/06/16.
//  Copyright © 2016 LiU. All rights reserved.
//

import Foundation
import UIKit

public class User: NSObject
{
    // Attribut för användaren
    var id : Int = 0
    var first_name: NSString = ""
    var email: NSString = ""
    var profile_pic_url: NSString = ""
    var date_of_birth: NSString = ""
    var events: NSArray = []
    
    // För apin
    var access_token: NSString = ""
    var refresh_token: NSString = ""
    var expires_in: Int = 0
    
    // Location för User
    var preffered_radius: Double = 0.0
    var longitude: Double = 0.0
    var latitude: Double = 0.0
    
    // För tempUser när ny användare registreras
    var tempPassword: String = ""
    var tempProfilPic: UIImageView
    
    
    override init() {
        // Gör saker när instansering sker
        self.tempProfilPic = UIImageView()
    }
    
    // MARK: Metoder
    func getAge() -> Int {
        // TODO: Implementera sa att man enkelt kan formatera alder hela tiden
        // User dob = "yyyy-MM-dd"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let d = dateFormatter.dateFromString(self.date_of_birth as String)
        // använder extension för NSDate fÖr att kunna hamta age
        return d!.age
    }
    
}

class SessionUser: User {
    // Singletion for den inloggade anvandaren
    static let thisInstance = SessionUser();
    
    private override init() {}
}


class UserManager {
    // Singleton Instans för att hantera alla användare
    static let thisManager = UserManager();
    
    // Attribut
    var users = [Int: User]()

    private init() {}
    
    func addUser(u:User) {
        self.users[u.id] = u
    }
    
    
    func getUserWithID(id:Int) -> User {
        let u = self.users[id]
        return u!
    }
    
    func asyncUserByID(user_id: Int, completion: (AnyObject?, ErrorType?)->()) {
        // Thread arbete till API
        let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            var dataTask: NSURLSessionDataTask?
    
        let eventPrefix = "/u_pk/" + String(user_id) + "/"
    
        let request = NSMutableURLRequest(URL: NSURL(string: AppManager.thisInstance.baseURL + eventPrefix)!)
        request.setValue("Bearer \(SessionUser.thisInstance.access_token as String)", forHTTPHeaderField: "Authorization")
    
    
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
    
    func parseUserJSON(dic: NSDictionary) -> User {
        if self.userExist(dic["pk"] as! Int) == false {
            let u = User()
            u.first_name = dic["first_name"] as! String
            u.profile_pic_url = dic["profile_picture"] as! String
            u.id = dic["pk"] as! Int
            u.date_of_birth = dic["date_of_birth"] as! String
            self.addUser(u)
            return u
        }
        else {
            let u = self.users[dic["pk"] as! Int]!
            return u
        }
        
    }
    
    func userExist(id: Int) -> Bool {
        if (self.users[id] != nil) {
            return true
        }
        return false
    }
    
    func userToJSON(user: User) -> NSJSONSerialization {
        let json = NSJSONSerialization()
        
        json.setValue(user.email, forKey: "email")
        json.setValue(user.first_name, forKey: "first_name")
        json.setValue(user.tempPassword, forKey: "password")
        
        let quality = CGFloat(1.0)
        let imageData: NSData = UIImageJPEGRepresentation(user.tempProfilPic.image!, quality)!
        
        let imageDataBase64 = imageData.base64EncodedStringWithOptions([])
        json.setValue(imageDataBase64, forKey: "profile_picture")
        
        return json
    }
    
    func registerUser(tempUser: User, completion: (AnyObject?, ErrorType?)->()) {
        // Thread arbete till API
        
        do {
            let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            var dataTask: NSURLSessionDataTask?
        
            let request = NSMutableURLRequest(URL: NSURL(string: AppManager.thisInstance.baseURL + "/sign_up/")!)
            
            request.HTTPMethod = "POST";
            
            let param = [
                "email" : String(tempUser.email),
                "first_name" : String(tempUser.first_name),
                "password" : String(tempUser.tempPassword),
                "date_of_birth" : String(tempUser.date_of_birth),
            ]
            
            let boundary = generateBoundaryString()
            
            request.setValue("application/json; multipart/form-data;", forHTTPHeaderField: "Content-Type")
            
            
            let imageData = UIImageJPEGRepresentation(tempUser.tempProfilPic.image!, 1)
            
            if(imageData==nil)  { return; }
            
            request.HTTPBody = createBodyWithParameters(param, filePathKey: "profile_picture", imageDataKey: imageData!, boundary: boundary, user: tempUser)
            
            
            // Starta dataTask
            dataTask = defaultSession.dataTaskWithRequest(request) {data, response, error in
            
                        // 8
            if let error = error {
                completion(nil, error)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    
                    do {
                        let NSJSONDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        completion(NSJSONDict, nil)
                        
                    } catch let error as NSError {
                        completion(nil, error)
                    }
                    
                } else {
                    completion(nil, error)
                }
            }
            
        } // end DataTask
        // 9
        dataTask?.resume()
        } catch {
            print(error)
        }
    }
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String, user: User) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = String(user.date_of_birth) + "_" + String(random()) + ".jpg";
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
}