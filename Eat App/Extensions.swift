//
//  Extensions.swift
//  Eat App
//
//  Created by vmware on 22/06/16.
//  Copyright © 2016 LiU. All rights reserved.
//

import Foundation
import UIKit


extension NSDate {
    // forlang NSDate sa man kan rakna ut alder pa Users osv
    var age: Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: self, toDate: NSDate(), options: []).year
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalizedString
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

// UIColor extension for att kunna anvanda HEX colors som init
// anvandning: var color = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF)
//      eller  var color2 = UIColor(netHex:0xFFFFFF)
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
}

extension NSMutableData {
    
    // lagger till string i nsdata
    func appendString(value : String) {
        value.withCString {
            self.appendBytes($0, length: Int(strlen($0)) + 1)
        }
    }
}