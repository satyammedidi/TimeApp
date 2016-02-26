//
//  LoginWindow.swift
//  TimeTime
//
//  Created by medidi vv satyanarayana murty on 02/02/16.
//  Copyright © 2016 Medidi vv satyanarayana murty. All rights reserved.
//

import Cocoa

class LoginWindow: NSWindowController
{
    @IBOutlet var userName: NSTextField!
    @IBOutlet var password: NSSecureTextField!
    @IBOutlet var loginButton: NSButton!
    
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    
    var timeSheetLayout:TimeSheetWindow? = nil
    var forgotPassword:ForgotPasswordWindow? = nil
    
    override func windowDidLoad()
    {
        super.windowDidLoad()
        if let storedUsername = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String
        {
            userName.stringValue = storedUsername as String
            loginButton.title = "LogIn"
            loginButton.tag = loginButtonTag
         }
        else
        {
             print(" No user Found ")
             loginButton.title = "Create"
             loginButton.tag = createLoginButtonTag
         }
    }
    
    override var windowNibName:String
    {
        return "LoginWindow"
    }
    
    @IBAction func resetFields(sender: NSButton)
    {
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("username")
        defaults.removeObjectForKey("pasword")
        password.stringValue = ""
        userName.stringValue = ""
        windowDidLoad()
    }
    
    @IBAction func forgotPassword(sender: NSButton)
    {
        self.window?.close()
        let fpwc = ForgotPasswordWindow(windowNibName: "ForgotPasswordWindow")
        fpwc.showWindow(self)
        forgotPassword = fpwc
    }
    
    @IBAction func login(sender: NSButton)
    {
        if sender.tag == loginButtonTag
        {
            
            if (userName.stringValue == "" || password.stringValue == "")
            {
                let alert = NSAlert()
                alert.messageText = "Error"
                alert.informativeText = "Password Should Notbe Empty"
                alert.runModal()
                return
            }
            
            if checkLogin(userName.stringValue, password: password.stringValue)
            {
                let alert = NSAlert()
                alert.messageText = "Success"
                alert.informativeText = "Successfully Login"
                alert.runModal()
                password.stringValue = ""
                self.window?.close()
                let ts = TimeSheetWindow(windowNibName: "TimeSheetWindow")
                ts.showWindow(self)
                timeSheetLayout = ts
            }
                
            else
            {
                let alert = NSAlert()
                alert.messageText = "Error"
                alert.informativeText = "Wrong Password "
                password.stringValue = ""
                alert.runModal()
            }
            
            
        }
        else
        {
            if (userName.stringValue == "" || password.stringValue == "")
            {
                let alert = NSAlert()
                alert.messageText = "Error"
                alert.informativeText = " Creation Failed "
                alert.runModal()
                return
            }
            else
            {
                let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(userName.stringValue, forKey: "username")
                defaults.setObject(password.stringValue, forKey: "password")
                
                let alert = NSAlert()
                alert.messageText = "Success"
                alert.informativeText = "Successfully Created"
                alert.runModal()
                password.stringValue = ""
                userName.stringValue = ""
                windowDidLoad()

            }
        }
    }
}





    func checkLogin(username: String, password: String ) -> Bool
    {
       if password == NSUserDefaults.standardUserDefaults().valueForKey("password") as? String &&
            username == NSUserDefaults.standardUserDefaults().valueForKey("username") as? String
       {
          return true
       }
       else
       {
         return false
       }
    }
    
    
    
  
///////create login/create button by code
//            let pstyle = NSMutableParagraphStyle()
//            pstyle.alignment = .CenterTextAlignment
//            loginButton.attributedTitle = NSAttributedString(string: "Create", attributes: [ NSForegroundColorAttributeName : NSColor.blackColor(), NSParagraphStyleAttributeName : pstyle ])
//
