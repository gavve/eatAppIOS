//
//  RegistrationVC.swift
//  Eat App
//
//  Created by vmware on 28/06/16.
//  Copyright © 2016 LiU. All rights reserved.
//

import UIKit

class RegistrationVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var profilePicV: UIImageView!
    var profilePictureVisible: Bool = false
    var birthdayPickerVisible: Bool = false
    @IBOutlet weak var profilePicCell: UITableViewCell!
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var displayBirthdayLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var pwStrengthIndicator: UILabel!
    
    let tempUser: User = User() // Temporärt ny användare
    
    var imageView: UIImageView?
    var profilePic: UIImage?
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    // MARK: methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // initial setip
        self.profilePictureVisible = false
        self.profilePicV.hidden = true
        self.profilePicV.translatesAutoresizingMaskIntoConstraints = false
        self.profilePicV.image = UIImage(named: "defaultProfilePic")
        self.birthdayPickerVisible = false
        self.birthdayPicker.hidden = true
        self.birthdayPicker.translatesAutoresizingMaskIntoConstraints = false
        
        // Registrerande användare måste vara över 18
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let currentDate: NSDate = NSDate()
        let components: NSDateComponents = NSDateComponents()
        
        components.year = -18
        let maxDate: NSDate = gregorian.dateByAddingComponents(components, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
        
        components.year = -150
        let minDate: NSDate = gregorian.dateByAddingComponents(components, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
        
        self.birthdayPicker.minimumDate = minDate
        self.birthdayPicker.maximumDate = maxDate
        self.birthdayPicker.date = maxDate
        self.birthdayPicker.locale = NSLocale(localeIdentifier: "sv_SV")
        
        self.saveButton.backgroundColor = AppManager.thisInstance.green
        self.pwStrengthIndicator.text = ""
        
        
        // sätt delegatet
        imagePicker.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.sectionIndexBackgroundColor = AppManager.thisInstance.blue
        self.tableView.sectionIndexColor = UIColor.whiteColor()
        

    }
    @IBAction func handleRegistration(sender: UIButton) {
        if validateUserData() {
            
            UserManager.thisManager.registerUser(self.tempUser) { (result, error) in
                if let result = result {
                    // registrering lyckads. Visa en alert här kanske
                    
                    print("registrering lyckades!")
                } else {
                    // handle error
                }
            }
        }
    }
    
    // MARK: Methods for ImagePicker
    
    func handleImagePicker() {
        let actionMenu = UIAlertController(title: "Use camera or select a photo from your albums", message: nil, preferredStyle:
            UIAlertControllerStyle.ActionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let takePhotoAction = UIAlertAction(title: "Use camera", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) -> Void in
                //print("take Photo")
                self.displayPickerController(UIImagePickerControllerSourceType.Camera)
            
            })
            // lägg till om album finns
            actionMenu.addAction(takePhotoAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let chooseAlbumAction = UIAlertAction(title: "Select from photo albums", style: UIAlertActionStyle.Default, handler: {(alert:   UIAlertAction!) -> Void in
                //print("choose Photo")
                self.displayPickerController(UIImagePickerControllerSourceType.PhotoLibrary)
            })
            // lägg till om kameran finns tillgänglig
            actionMenu.addAction(chooseAlbumAction)
        }
        
        presentViewController(actionMenu, animated: true, completion: nil)
    }
    
    // MARK: Hjälpfunktion till handleImagePicker
    func displayPickerController(sourceType: UIImagePickerControllerSourceType) {
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func chooseAnotherPic(sender: UIButton) {
        handleImagePicker()
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profilePicV.contentMode = .ScaleAspectFit
            //let size = CGSize(width: screenSize.width * 0.9, height: screenSize.width * 0.9)
            self.profilePicV.image = getFramedImage(pickedImage) // gör bilden fyrkantig
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Start birthdaypicker cell show/hide methods
    func showBirthdayCell() {
        self.birthdayPickerVisible = true;
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        self.birthdayPicker.hidden = false;
        self.birthdayPicker.alpha = 0.0
        
        UIView.animateWithDuration(0.25, delay: 1.0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            self.birthdayPicker.alpha = 1.0
            }, completion: { (finished: Bool) -> Void in
                
        })
    }
    
    func hideBirtdayCell() {
        self.birthdayPickerVisible = false
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
        UIView.animateWithDuration(0.25, delay: 1.0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            self.birthdayPicker.alpha = 0.0
            }, completion: { (finished: Bool) -> Void in
                self.birthdayPicker.hidden = true
        })
    }
    
    // MARK: Start profileCell show/hide methods
    func showProfilePicCell() {
        self.profilePictureVisible = true;
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        self.profilePicV.hidden = false;
        self.profilePicV.alpha = 0.0
       
        
        UIView.animateWithDuration(0.25, delay: 1.0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            self.profilePicV.alpha = 1.0
            }, completion: { (finished: Bool) -> Void in
                
        })
    }
    
    func hideProfilePicCell() {
        self.profilePictureVisible = false
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
        UIView.animateWithDuration(0.25, delay: 1.0, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            self.profilePicV.alpha = 0.0
            }, completion: { (finished: Bool) -> Void in
                self.profilePicV.hidden = true
        })
    }
    
    // MARK: Method for UIDatePicker action
    @IBAction func handleUIdatePickerAction(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d MMMM y"
        dateFormatter.locale = NSLocale(localeIdentifier: "sv_SV")
        
        let strDate = dateFormatter.stringFromDate(sender.date)
        self.displayBirthdayLabel.text = strDate
    }
    
    
    // MARK: Overriding tablieView funcitons
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat = CGFloat(self.tableView.rowHeight)
        // satter hojden for uiimage cellen beroende pa om den ska visas eller inte
        if (indexPath.row == 2 && indexPath.section == 1) {
            if self.profilePictureVisible == true {
                height = 450.0
            } else {
                height = 0.0
            }
        }
        
        // samma som ovan fast for datepicker (birthday) cellen
        if (indexPath.row == 2 && indexPath.section == 2) {
            if self.birthdayPickerVisible == true {
                height = 216.0
            } else {
                height = 0.0
            }
        }
        
        return height
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 1 && indexPath.section == 1) // choose profilepic button row
        {
            if (self.profilePictureVisible){
                self.hideProfilePicCell()
            } else {
                handleImagePicker()
                self.showProfilePicCell()
            }
        }
        
        if (indexPath.row == 0 && indexPath.section == 2) // sätt datum för födelsedag
        {
            if (self.birthdayPickerVisible){
                self.hideBirtdayCell()
            } else {
                self.showBirthdayCell()
            }
        }
        print(String(indexPath.row) + " section: " + String(indexPath.section))
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: User interactable methods
    
    @IBAction func givePasswordStrenghtFeedback(sender: UITextField) {
        let level = PasswordStrength.checkStrength(sender.text!)
        print("hej")
        if(level == PasswordStrength.None) {
            self.pwStrengthIndicator.text = "No strength"
            self.pwStrengthIndicator.textColor = UIColor.lightGrayColor()
        }
        if(level == PasswordStrength.Weak) {
            self.pwStrengthIndicator.text = "Weak"
            self.pwStrengthIndicator.textColor = UIColor.redColor()
        }
        if(level == PasswordStrength.Moderate) {
            self.pwStrengthIndicator.text = "Moderate"
            self.pwStrengthIndicator.textColor = AppManager.thisInstance.blue
        }
        if(level == PasswordStrength.Strong) {
            self.pwStrengthIndicator.text = "Strong"
            self.pwStrengthIndicator.textColor = AppManager.thisInstance.green
        }
        
        if self.isPassEqual(sender.text!, pass2: self.password2.text!) {
            self.password1.backgroundColor = UIColor(netHex:0x5cb85c)
            self.password2.backgroundColor = UIColor(netHex: 0x5bc0de)
        }
    }
    
    @IBAction func secondPasswordHandler(sender: UITextField) {
        // Allt kollas redan i första, så kolla endast så de är lika
        if self.isPassEqual(sender.text!, pass2: self.password2.text!) {
            self.password1.backgroundColor = UIColor(netHex:0x5cb85c)
            self.password2.backgroundColor = UIColor(netHex: 0x5bc0de)
        }
    }
    
    // MARK: Validation methods
    func isMailValid(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(email)
    }
    
    func isPassValid(passwd: String) -> Bool {
        
        if passwd.characters.count > 4 {
            // längre än 4
            return true
        }
        
        return false
    }
    
    func isPassEqual(pass1: String, pass2: String) -> Bool {
        // returnerar true om de ar lika
        if pass1 == pass2 {
            return true
        }
        return false
    }
    
    
    enum PasswordStrength: Int {
        case None
        case Weak
        case Moderate
        case Strong
        
        static func checkStrength(password: String) -> PasswordStrength {
            let len: Int = password.characters.count
            var strength: Int = 0
            
            switch len {
            case 0:
                return .None
            case 2...4:
                strength++
            case 5...8:
                strength += 2
            case 9...100:
                strength += 3
            default:
                strength == strength
            }
            
            // Upper case, Lower case, Number & Symbols
            let patterns = ["^(?=.*[A-Z]).*$", "^(?=.*[a-z]).*$", "^(?=.*[0-9]).*$", "^(?=.*[!@#%&-_=:;\"'<>,`~\\*\\?\\+\\[\\]\\(\\)\\{\\}\\^\\$\\|\\\\\\.\\/]).*$"]
            
            for pattern in patterns {
                if (password.rangeOfString(pattern, options: .RegularExpressionSearch) != nil) {
                    strength++
                }
            }
            
            switch strength {
            case 1:
                return .None
            case 2...3:
                return .Weak
            case 4...5:
                return .Moderate
            case 6...100:
                return .Strong
            default:
                return .None
            }
        }
    }
    
    func convertToAPIBirthdayFormatt() -> String {
        let apiStringFormatter = NSDateFormatter()
        apiStringFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = apiStringFormatter.stringFromDate(self.birthdayPicker.date)
        
        return dateString
    }
    
    
    // MARK: Creating new temp user from data
    func validateUserData() -> Bool {
        // Om allt valideras returnerar den true, om den stannar pa nagon
        // else sa returnerar den false
        
        if (isPassEqual(self.password1.text!, pass2: self.password2.text!)) {
            tempUser.tempPassword = self.password1.text!
        } else {
            return false
        }
        //--------------
        if (isMailValid(self.emailField.text!)) {
            tempUser.email = NSString(string: self.emailField.text!)
        } else {
            return false
        }
        //--------------
        if (self.profilePicV.image != nil) {
            tempUser.tempProfilPic = self.profilePicV
        } else {
            showProfilePicCell()
            self.profilePicCell.textLabel?.text = "Please select a profile picture"
            self.profilePicCell.textLabel?.textColor = UIColor.redColor()
            return false
        }
        //--------------
        if(self.firstname.text?.characters.count > 2) {
            tempUser.first_name = self.firstname.text!
        } else {
            return false
        }
        //--------------
        if (self.displayBirthdayLabel.text?.characters.count > 5) {
            let dob = convertToAPIBirthdayFormatt()
            tempUser.date_of_birth = dob
        } else {
            showBirthdayCell()
            self.displayBirthdayLabel.text = "Please select your birthday"
            self.displayBirthdayLabel.textColor = UIColor.redColor()
            return false
        }
        //--------------
        
        return true
    }
    
}
