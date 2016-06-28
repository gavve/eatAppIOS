//
//  AppManager.swift
//  Eat App
//
//  Created by vmware on 14/06/16.
//  Copyright © 2016 LiU. All rights reserved.
//

import Foundation
import UIKit

class AppManager {
    static let thisInstance = AppManager()
    var baseURL = "http://192.168.0.104:8000"
    
    // Colors for hela appen
    let green = UIColor(netHex:0x5cb85c)
    let blue = UIColor(netHex: 0x5bc0de)
    
    private init() {}
    
    // 3 Fixa authentication mot servern
    var client_id = "SO4C7wprBFxdqRiImlVLR9zMO6QdD2jpvh9mqHqY"
    var client_secret = "4Ehn6qjDpLooro2Mi5bXyMb3PpsesXIRF4u0wvt2l9YiAmjwmm9E6AvFHWmz2xPz0IhaESjaf2UsbXBhubVVN3U3zRbMnesXc3fw7r6CYY0FeRSUtIFxzWkrlZBckCQv"
    
    func getClientUrl() -> String {
        return "client_id=" + client_id + "&client_secret=" + client_secret
    }
    
}