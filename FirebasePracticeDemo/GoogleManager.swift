//
//  GoogleManager.swift
//  FirebasePracticeDemo
//
//  Created by Ankur Baranwal on 27/05/20.
//  Copyright © 2020 Ankur Baranwal. All rights reserved.
//

import Foundation
import Firebase
import GoogleSignIn

let rootViewController = appDelegate.window?.rootViewController

var appDelegate: AppDelegate{
    guard let delegate = UIApplication.shared.delegate as? AppDelegate else{
        fatalError("AppDelegate is not UIApplication.shared.delegate")
    }
    return delegate
}
protocol GoogleManagerDelegate: class{
    func googleSignInSuccess(_ user: GIDGoogleUser)
    func googleSignInFailure(_ message: String)
}

class GoogleManager: NSObject, GIDSignInDelegate{

    weak var delegate: GoogleManagerDelegate?
    static let googleCLientID = "581298536967-snnp3a6k994s12reaktfk2m186onp9vq.apps.googleusercontent.com"
    override init() {
        
    }
    
    func signIn(){
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().clientID = "581298536967-snnp3a6k994s12reaktfk2m186onp9vq.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        }else{
            print(user.profile.hasImage)
            print(user.profile.imageURL)
            self.delegate?.googleSignInSuccess(user)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if error != nil{
            self.delegate?.googleSignInFailure(error.localizedDescription)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        let window = appDelegate.window?.rootViewController
        viewController.modalPresentationStyle = .fullScreen
        window?.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!,dismiss viewController: UIViewController!)  {
        let window = appDelegate.window?.rootViewController
        window?.dismiss(animated: true, completion: nil)
    }
    
    
}
