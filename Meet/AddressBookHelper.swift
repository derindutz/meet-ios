//
//  AddressBookHelper.swift
//  Meet
//
//  Created by Derin Dutz on 11/27/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit
import Contacts

public class AddressBookHelper {
    
    // TODO: refetch contacts
    
    public class func getUsers() {
        requestForAccess { (accessGranted) -> Void in
            if accessGranted {
                let keys = [CNContactFormatter.descriptorForRequiredKeysForStyle(CNContactFormatterStyle.FullName), CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataKey]
                
                do {
                    let contactStore = self.contactStore
                    try contactStore.enumerateContactsWithFetchRequest(CNContactFetchRequest(keysToFetch: keys)) { (contact, pointer) -> Void in
                        getUser(contact)
                    }
                } catch let error as NSError {
                    print(error.description, separator: "", terminator: "\n")
                }
            }
        }
    }
    
    public class func getUser(contact: CNContact) -> User? {
        let user = User()
        user.firstName = contact.givenName
        user.lastName = contact.familyName
        user.profileImageData = contact.imageData
        
        user.emails = []
        for email: CNLabeledValue in contact.emailAddresses {
            user.emails.append(email.value as! String)
        }
        
        user.phoneNumbers = []
        for phoneNumber: CNLabeledValue in contact.phoneNumbers {
            let cnNumber = phoneNumber.value as! CNPhoneNumber
            let formattedNumber = cnNumber.stringValue
            let numberComponents = formattedNumber.componentsSeparatedByCharactersInSet(
                NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            let number = numberComponents.joinWithSeparator("")
            user.phoneNumbers.append(number)
        }
        
        for email in user.emails {
            let username = email
            if UserDatabase.containsUser(username) {
                user.username = username
                UserDatabase.updateUser(username, user: user)
                return user
            }
        }
        
        if let username = user.emails.first {
            user.username = username
//            let qos = QOS_CLASS_BACKGROUND
//            let backgroundQueue = dispatch_get_global_queue(qos, 0)
//            dispatch_async(backgroundQueue) {
//                UserDatabase.saveUserToDatabase(username, user: user)
//            }
            // TODO: save users to database
//            UserDatabase.saveUserToDatabase(username, user: user)
            UserDatabase.updateUser(username, user: user)
            return user
        }
        
        return nil
    }
    
//    public class func getUser(username: String) {
//        requestForAccess { (accessGranted) -> Void in
//            if accessGranted {
//                let keys = [CNContactFormatter.descriptorForRequiredKeysForStyle(CNContactFormatterStyle.FullName), CNContactPhoneNumbersKey, CNContactImageDataKey]
//                
//                do {
//                    let contactStore = self.contactStore
//                    try contactStore.enumerateContactsWithFetchRequest(CNContactFetchRequest(keysToFetch: keys)) { (contact, pointer) -> Void in
//                        for phoneNumber: CNLabeledValue in contact.phoneNumbers {
//                            let cnNumber = phoneNumber.value as! CNPhoneNumber
//                            let formattedNumber = cnNumber.stringValue
//                            let numberComponents = formattedNumber.componentsSeparatedByCharactersInSet(
//                                NSCharacterSet.decimalDigitCharacterSet().invertedSet)
//                            let number = numberComponents.joinWithSeparator("")
//                            if username == number {
//                                let user = User()
//                                user.username = number
//                                user.firstName = contact.givenName
//                                user.lastName = contact.familyName
//                                user.profileImageData = contact.imageData
//                                UserDatabase.addUser(user)
//                                return
//                            }
//                        }
//                    }
//                } catch let error as NSError {
//                    print(error.description, separator: "", terminator: "\n")
//                }
//            }
//        }
//    }
//    
//    public class func getUserByName(name: String) -> User? {
//        var foundUser: CNContact?
//        
//        requestForAccess { (accessGranted) -> Void in
//            if accessGranted {
//                let predicate = CNContact.predicateForContactsMatchingName(name)
//                let keys = [CNContactFormatter.descriptorForRequiredKeysForStyle(CNContactFormatterStyle.FullName), CNContactPhoneNumbersKey, CNContactImageDataKey]
//                var contacts = [CNContact]()
//                
//                let contactStore = self.contactStore
//                do {
//                    contacts = try contactStore.unifiedContactsMatchingPredicate(predicate, keysToFetch: keys)
//                    
//                    if contacts.isEmpty {
//                        return
//                    }
//                    
//                    foundUser = contacts.first
//                } catch {
//                    return
//                }
//            }
//        }
//        
//        if let contact = foundUser {
//            for phoneNumber: CNLabeledValue in contact.phoneNumbers {
//                if let cnNumber = phoneNumber.value as? CNPhoneNumber {
//                    let formattedNumber = cnNumber.stringValue
//                    let numberComponents = formattedNumber.componentsSeparatedByCharactersInSet(
//                        NSCharacterSet.decimalDigitCharacterSet().invertedSet)
//                    let number = numberComponents.joinWithSeparator("")
//                    
//                    let user = User()
//                    user.username = number
//                    user.firstName = contact.givenName
//                    user.lastName = contact.familyName
//                    user.profileImageData = contact.imageData
//                    
//                    print("got here!")
//                    
//                    UserDatabase.addUser(user)
//                    
//                    print("finished")
//                    return user
//                }
//            }
//        }
//        
//        return nil
//    }
    
    private static var contactStore = CNContactStore()
    
    private class func getAppDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    public class func showMessage(message: String) {
        let alertController = UIAlertController(title: "Meet", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) -> Void in
        }
        
        alertController.addAction(dismissAction)
        
        if let root = getAppDelegate().window?.rootViewController as? UINavigationController {
            let presentedViewController = root.viewControllers[root.viewControllers.count - 1]
            presentedViewController.presentViewController(alertController, animated: true, completion: nil)
        } else if let presentedViewController = getAppDelegate().window?.rootViewController {
            presentedViewController.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    private class func requestForAccess(completionHandler: (accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        
        switch authorizationStatus {
        case .Authorized:
            completionHandler(accessGranted: true)
            
        case .Denied, .NotDetermined:
            self.contactStore.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(accessGranted: access)
                } else {
                    if authorizationStatus == CNAuthorizationStatus.Denied {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow Meet to access your contacts through the Settings App."
                            showMessage(message)
                        })
                    }
                }
            })
            
        default:
            completionHandler(accessGranted: false)
        }
    }

}