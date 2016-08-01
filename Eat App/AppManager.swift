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
    var baseURL = "http://192.168.1.82:8000"
    
    // Colors for hela appen
    let green = UIColor(netHex:0x5cb85c)
    let blue = UIColor(netHex: 0x5bc0de)
    
    private init() {}
    
    // 3 Fixa authentication mot servern
    var client_id = "7shAYjK6wNasY2H9st9chn8tEQA1WDH04HmXxgVV"
    var client_secret = "IxyXe7aO95JkvsTVxJ3XREg6XZ3CB7IYFC7uBkyUmqSOrfd1sPSuPbFEzyK4BXR15p9pPEks1Gdayl8V917HA6NtCO3b1YQWfFpsjd8jB0cUMe1n0LUDUf6ocFtsaVIP"
    
    func getClientUrl() -> String {
        return "client_id=" + client_id + "&client_secret=" + client_secret
    }
    
}