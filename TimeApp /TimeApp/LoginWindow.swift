//
//  LoginWindow.swift
//  TimeTime
//
//  Created by medidi vv satyanarayana murty on 02/02/16.
//  Copyright © 2016 Medidi vv satyanarayana murty. All rights reserved.
//

import Cocoa
import SecurityFoundation

//let keychain_keyName = "password"



class LoginWindow: NSWindowController
{
    @IBOutlet var userName: NSTextField!
    @IBOutlet var password: NSSecureTextField!
    @IBOutlet var loginButton: NSButton!
    
   let keyChain = KeychainSwift()
    
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    
    
    
    var timeSheetLayout:TimeSheetWindow? = nil
    var forgotPassword:ForgotPasswordWindow? = nil
    
    override func windowDidLoad()
    {
        super.windowDidLoad()
        
        if let _ = NSUserDefaults.standardUserDefaults().valueForKey("username")
        {
           
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
        loginButton.title = "Create"
        loginButton.tag = createLoginButtonTag
     
    }
    
    @IBAction func forgotPassword(sender: NSButton)
    {
        self.window?.close()
        let forgot = ForgotPasswordWindow(windowNibName: "ForgotPasswordWindow")
        forgot.showWindow(self)
        forgotPassword = forgot
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
                let time = TimeSheetWindow(windowNibName: "TimeSheetWindow")
                time.showWindow(self)
                timeSheetLayout = time
            }
                
            else
            {
                let alert = NSAlert()
                alert.messageText = "Error"
                alert.informativeText = "Entered Wrong Password "
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
                let hasKey = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
                if hasKey == false
                {
                    NSUserDefaults.standardUserDefaults().setObject(userName.stringValue, forKey: "userName")
                }
                
                
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasPassword")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                keyChain.set(password.stringValue, forKey: "password")
                
            
                let alert = NSAlert()
                alert.messageText = "Success"
                alert.informativeText = "Successfully Created"
                alert.runModal()
                password.stringValue = ""
               
                loginButton.title = "LogIn"
                loginButton.tag = loginButtonTag

                

            }
        }
    }






func checkLogin(username: String, password: String ) -> Bool
{
    if (password == keyChain.get ("password")) && username == (NSUserDefaults.standardUserDefaults().valueForKey("userName") as? String)!
    {
        return true
    }
    else
    {
        return false
    }
    
}


}

///////create login/create button by code
//            let pstyle = NSMutableParagraphStyle()
//            pstyle.alignment = .CenterTextAlignment
//            loginButton.attributedTitle = NSAttributedString(string: "Create", attributes: [ NSForegroundColorAttributeName : NSColor.blackColor(), NSParagraphStyleAttributeName : pstyle ])
//
