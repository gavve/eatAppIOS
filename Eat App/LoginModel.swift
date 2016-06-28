//
//  LoginModel.swift
//  Eat App
//
//  Created by vmware on 14/06/16.
//  Copyright © 2016 LiU. All rights reserved.
//

import Foundation


class LoginModel {
    let appManager = AppManager.thisInstance
    let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var dataTask: NSURLSessionDataTask?
    let apiRequest = APIRequest.thisInstance
    
    func validateLogin(username: String, password: String) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
            // 6
            self.dataTask = self.defaultSession.dataTaskWithRequest((self.apiRequest.getToken(username, password: password))) {data, response, error in
                
                // 8
                if let error = error {
                    print(error.localizedDescription)
                    self.showError()
                } else if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        
                        do {
                            let jsonDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                            
                            self.parseJSON(jsonDict)
                            
                        } catch let error as NSError {
                            print("Json error: \(error.localizedDescription)")
                            self.showError()
                        }
                        
                    }
                    self.showError()
                }
                
            } // end DataTask
            // 9
            self.dataTask?.resume()
        }
        
    }
    
    
    func showError() {
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            print("vi fick ett error i asyncLogin")
        }
    }
    
    func parseJSON(json: NSDictionary) {
        SessionUser.thisInstance.access_token = json["access_token"] as! String
        SessionUser.thisInstance.refresh_token = json["refresh_token"] as! String
        SessionUser.thisInstance.expires_in = json["expires_in"] as! Int
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            
        }
    }
}