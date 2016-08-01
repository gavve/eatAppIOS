//
//  LoginViewController.swift
//  Eat App
//
//  Created by vmware on 14/06/16.
//  Copyright © 2016 LiU. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LoginViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var dataTask: NSURLSessionDataTask?
    
    let appManager = AppManager.thisInstance
    let apiRequest = APIRequest.thisInstance
    
    // Location manager
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Sätter färg pa knapparna
        self.signInButton.backgroundColor = appManager.green
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        SessionUser.thisInstance.latitude = 51.811883
        SessionUser.thisInstance.longitude = 5.815264
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK -: locationmanager setup
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        SessionUser.thisInstance.latitude = locValue.latitude
        SessionUser.thisInstance.longitude = locValue.longitude
        // Sluta updatera for att spara batteri ??
    }
    
    // MARK : Async tasks for retrieving user information
    
    func validateLogin(username: String, password: String, completion: (AnyObject?, ErrorType?)->()) {
            // 6
            self.dataTask = self.defaultSession.dataTaskWithRequest((self.apiRequest.getToken(username, password: password))) {data, response, error in
                
                // 8
                if let error = error {
                    print(error.localizedDescription)
                    completion(nil, error)
                } else if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        
                        do {
                            let jsonDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                            completion(jsonDict, nil)
                            
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
            self.dataTask?.resume()
        
    }

    
    func asyncGetUserData(completion: (AnyObject?, ErrorType?)->()) {
        // Thread arbete till API
        let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        var dataTask: NSURLSessionDataTask?
            
            
            let request = NSMutableURLRequest(URL: NSURL(string: AppManager.thisInstance.baseURL + "/u/"+(SessionUser.thisInstance.email as String))!)
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
        
        print("vi fick ett error i asyncLogin")
    }
    
    
    func parseJSON(json: NSDictionary, normal: Bool) {
        // funktion for att parsa access_token osv
        // Sparar attribut till SessionUser (den inloggade anvandaren)
        if normal {
            SessionUser.thisInstance.first_name = json["first_name"] as! String
            SessionUser.thisInstance.id = json["pk"] as! Int
            SessionUser.thisInstance.date_of_birth = json["date_of_birth"] as! String
            SessionUser.thisInstance.profile_pic_url = json["profile_picture"] as! String
            SessionUser.thisInstance.email = json["email"] as! String
            SessionUser.thisInstance.events = json["events"] as! NSArray
            print(json)
        
        } else {
            SessionUser.thisInstance.access_token = json["access_token"] as! String
            SessionUser.thisInstance.refresh_token = json["refresh_token"] as! String
            SessionUser.thisInstance.expires_in = json["expires_in"] as! Int
            print(json)
        }
    }
    
    
    // MARK: UI methods
    
    @IBAction func signInButton(sender: AnyObject) {
        // Implementera checks for email och losenord
    
            SessionUser.thisInstance.email = self.emailField.text!
            self.validateLogin(self.emailField.text!, password: self.passwordField.text!) { (result1, error) in
                if let result1 = result1 {
                    // process result1
                    self.parseJSON(result1 as! NSDictionary, normal: false)
                    self.asyncGetUserData() { (result2, error) in
                        if let result2 = result2 {
                            // process result2
                            self.parseJSON(result2 as! NSDictionary, normal: true)
                            // nar bada stegen ar klara kan vi utfora segue till events
                            self.goToNextView()
                        } else {
                            // handle error
                        }
                    }
                } else {
                    // handle error
                }
            }
    }
    
    func goToNextView() {
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            // utfor segue i sparad i main-thread
            self.performSegueWithIdentifier("loginSuccess", sender: self)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "loginSuccess" {
            let svc = segue.destinationViewController as! UINavigationController
        }
    }

}