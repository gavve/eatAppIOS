//
//  JSONParser.swift
//  Eat App
//
//  Created by vmware on 13/06/16.
//  Copyright © 2016 LiU. All rights reserved.
//

import UIKit

@objc protocol APIRequestDelegate: class {
    func login() -> NSString
    func tokenGeneratorDidFail(controller: APIRequest, response: NSString)
}

class APIRequest:NSObject {
    
    static var thisInstance = APIRequest() // Singleton
    
    private override init() {}
    
    func getToken(username: String, password:String) -> NSMutableURLRequest {

        // 3 Fixa authentication mot servern
        let client_id = "SO4C7wprBFxdqRiImlVLR9zMO6QdD2jpvh9mqHqY"
        let client_secret = "4Ehn6qjDpLooro2Mi5bXyMb3PpsesXIRF4u0wvt2l9YiAmjwmm9E6AvFHWmz2xPz0IhaESjaf2UsbXBhubVVN3U3zRbMnesXc3fw7r6CYY0FeRSUtIFxzWkrlZBckCQv"
        
        let clientPart = "client_id=" + client_id + "&client_secret=" + client_secret
        let userPart =  "&grant_type=password&username=" + username + "&password=" + password
        let postString = clientPart + userPart
        
        // 5 satt request metoder
        let request = NSMutableURLRequest(URL: NSURL(string: AppManager.thisInstance.baseURL + "/o/token/")!)
        request.HTTPMethod = "POST"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        return request
        
    }
    
    


}
