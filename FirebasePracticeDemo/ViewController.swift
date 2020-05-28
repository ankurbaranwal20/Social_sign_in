//
//  ViewController.swift
//  FirebasePracticeDemo
//
//  Created by Ankur Baranwal on 15/05/20.
//  Copyright © 2020 Ankur Baranwal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import AuthenticationServices
import GoogleSignIn
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit


@available(iOS 13.0, *)
class ViewController: UIViewController {

    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var appleSignInbutton: UIButton!
    @IBOutlet weak var socialView: UIView!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var mobField: UITextField!
    var id: String = ""
    
    let googleManager = GoogleManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().languageCode = "en";
//        GIDSignIn.sharedInstance().uiDelegate = self
//        let ref = Database.database().reference()
        
//        ref.child("user1/name").setValue("Harsh")
//        ref.child("ANkur").child("user2").setValue(["name": "Ankit", "age": "27", "role": "Warehouse lead"])
//        ref.child("ANkur").child("user4").setValue(["name": "Amit", "age": "20", "role": "Civil"])
//        ref.child("ANkur").child("user5").setValue(["name": "Arun", "age": "23", "role": "lead"])
        
//        ref.child("ANkur").child("user2").observe(.value) { (DataSnapshot) in
//            print(DataSnapshot.children)
//        }
//        let updates = ["user1/name": "Satyam"]
//        ref.updateChildValues(updates)
//        ref.child("ANkur").removeValue()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        //Mark :- Apple sign in Button
        setAppleSignInbutton()
        setSocialLoginButton()
//        GIDSignIn.sharedInstance().delegate = self
        self.googleManager.delegate = self
    }
    // Mark :- Google and facebook Button Ui
    func setSocialLoginButton(){
        googleButton.layer.cornerRadius = 5.0
        googleButton.layer.shadowRadius = 10.0
        googleButton.layer.shadowColor = UIColor.gray.cgColor
        googleButton.layer.borderColor = UIColor.black.cgColor
        googleButton.layer.borderWidth = 2.0
        googleButton.layer.shadowOpacity = 1.0
        googleButton.layer.masksToBounds = false
        facebookButton.layer.shadowRadius = 10.0
        facebookButton.layer.cornerRadius = 5.0
        facebookButton.layer.shadowColor = UIColor.gray.cgColor
        facebookButton.layer.shadowOpacity = 1.0
        facebookButton.layer.masksToBounds = false
    }
    
    func setAppleSignInbutton(){
//        let appleSignInButton = ASAuthorizationAppleIDButton()
        appleSignInbutton.layer.cornerRadius = 5.0
        appleSignInbutton.layer.borderColor = UIColor.black.cgColor
        appleSignInbutton.layer.borderWidth = 2.0
//        socialView.layer.borderColor = UIColor.black.cgColor
//        socialView.layer.cornerRadius = 5.0
        appleSignInbutton.addTarget(self, action: #selector(handleAppleSignInAction), for: .touchUpInside)
        
    }
    
    @objc func handleAppleSignInAction(){
        let appleIdProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIdProvider.createRequest()
//        request.requestedScopes = [.email, .fullName]
        
        let request = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: request)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    //Mark - : Google Sign in
    
    @IBAction func googleButtonAction(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
////        GIDSignIn.sharedInstance().signOut()
//        GIDSignIn.sharedInstance().clientID = "2464465512-cjoiaqm12uuhrus3lhbnlq787mhdmtm8.apps.googleusercontent.com"
//        GIDSignIn.sharedInstance().signIn()
        self.googleManager.signIn()
        // Automatically sign in the user.
//        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    @IBAction func facebookButtonAction(_ sender: Any) {
        CommonFunctionForFaceBookLogin(viewControler: self, fbDataOnSucess: { (firstName, lastName, email, fbId, pictureUrl) in
            print(firstName)
        }) { (error) in
            print(error)
        }
    }
    
    

    @IBAction func signInAction(_ sender: Any) {
//        sentLinkToMail()
        sendOtp()
    }
    @IBAction func signUpAction(_ sender: Any) {
        self.registerWithOtp(verificationID: self.id)
    }
    
    func sendOtp(){
        PhoneAuthProvider.provider().verifyPhoneNumber("+91" + mobField.text!, uiDelegate: nil) { (verificationID, error) in
          if let error = error {
//            self.showMessagePrompt(error.localizedDescription)
            return
          }
          // Sign in using the verificationID and the code sent to the user
          // ...
            self.id = verificationID ?? ""
            
        }
    }
    
    func registerWithOtp(verificationID: String){
        let credential = PhoneAuthProvider.provider().credential(
        withVerificationID: verificationID,
        verificationCode: passField.text!)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            let authError = error as NSError
//            if (isMFAEnabled && authError.code == AuthErrorCode.secondFactorRequired.rawValue) {
//              // The user is a multi-factor user. Second factor challenge is required.
//              let resolver = authError.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
//              var displayNameString = ""
//              for tmpFactorInfo in (resolver.hints) {
//                displayNameString += tmpFactorInfo.displayName ?? ""
//                displayNameString += " "
//              }
//              self.showTextInputPrompt(withMessage: "Select factor to sign in\n\(displayNameString)", completionBlock: { userPressedOK, displayName in
//                var selectedHint: PhoneMultiFactorInfo?
//                for tmpFactorInfo in resolver.hints {
//                  if (displayName == tmpFactorInfo.displayName) {
//                    selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
//                  }
//                }
//                PhoneAuthProvider.provider().verifyPhoneNumber(with: selectedHint!, uiDelegate: nil, multiFactorSession: resolver.session) { verificationID, error in
//                  if error != nil {
//                    print("Multi factor start sign in failed. Error: \(error.debugDescription)")
//                  } else {
//                    self.showTextInputPrompt(withMessage: "Verification code for \(selectedHint?.displayName ?? "")", completionBlock: { userPressedOK, verificationCode in
//                      let credential: PhoneAuthCredential? = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!, verificationCode: verificationCode!)
//                      let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator.assertion(with: credential!)
//                      resolver.resolveSignIn(with: assertion!) { authResult, error in
//                        if error != nil {
//                          print("Multi factor finanlize sign in failed. Error: \(error.debugDescription)")
//                        } else {
//                          self.navigationController?.popViewController(animated: true)
//                        }
//                      }
//                    })
//                  }
//                }
//              })
//            } else {
////              self.showMessagePrompt(error.localizedDescription)
//              return
//            }
            // ...
            return
          }
          // User is signed in
          // ...
            print("SignedIn with no of \(self.mobField.text ) -> \(self.passField.text)")
        }
    }
    
    func sentLinkToMail(){
        
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "example.firebase.practice")
        // The sign-in operation has to always be completed in the app.
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        actionCodeSettings.setAndroidPackageName("com.ankur.FirebasePracticeDemo",
                                                 installIfNotAvailable: false, minimumVersion: "12")
        
        Auth.auth().sendSignInLink(toEmail:mobField.text!,
                                   actionCodeSettings: actionCodeSettings) { error in
          // ...
            if let error = error {
//              self.showMessagePrompt(error.localizedDescription)
              return
            }
            // The link was successfully sent. Inform the user.
            // Save the email locally so you don't need to ask the user for it again
            // if they open the link on the same device.
            UserDefaults.standard.set(self.mobField.text!, forKey: "Email")
//            self.showMessagePrompt("Check your email for link")
            // ...
        }
    }
}
@available(iOS 13.0, *)
extension ViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.presentationAnchor(for: controller)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization){
        if let appleIDCreds = authorization.credential as? ASAuthorizationAppleIDCredential{
            
            let userIdentifier = appleIDCreds.user
            
            let fullName = appleIDCreds.fullName
            let email = appleIDCreds.email
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userIdentifier) {  (credentialState, error) in
                 switch credentialState {
                    case .authorized:
                        // The Apple ID credential is valid.
                        break
                    case .revoked:
                        // The Apple ID credential is revoked.
                        break
                 case .notFound: break
                        // No credential was found, so show the sign-in UI.
                    default:
                        break
                 }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
        print(error.localizedDescription)
    }
}
@available(iOS 13.0, *)
extension ViewController: GoogleManagerDelegate{
    func googleSignInSuccess(_ user: GIDGoogleUser) {
        print(user.profile.email)
        print(user.profile.hasImage)
        print(user.profile.imageURL(withDimension: 200)?.absoluteString ?? "")
        print(user.userID)
    }
    
    func googleSignInFailure(_ message: String) {
        
    }
    
    
}
@available(iOS 13.0, *)
extension ViewController{
    
    typealias faceBookCompletion = (_ firstName:String,_ lastName:String,_ email:String,_ id:String, _ pictureUrl:String)->Void
    
    func CommonFunctionForFaceBookLogin(viewControler:UIViewController,fbDataOnSucess:@escaping faceBookCompletion,onfaLiure:@escaping (_ error:NSError) -> Void){
            var firstName = String()
            var lastName = String()
            var emailId = String()
            var id = String()
            var pictureUrl = String()
//            if IJReachability.isConnectedToNetwork() == true{
//                if AccessToken.current != nil{
//                    let loginManager = LoginManager()
//                    loginManager.logOut()
//                }
                let fbLoginManager : LoginManager = LoginManager()
//                fbLoginManager.loginBehavior = LoginBehavior.browser
                fbLoginManager.logIn(permissions: ["email"], from: viewControler) { (result, error) -> Void in
                    print(result)
                    switch error{
                    case nil:
                        let fbloginresult : LoginManagerLoginResult = result!
                        print(fbloginresult.isCancelled)
                        switch fbloginresult.isCancelled{
                        case false:
                            switch AccessToken.current{
                            case nil:
                                break
                            default:
    //                            ViewControllerUtils.sharedInstance.showActivityIndicator(uiView: viewControler.view)
                               
                                GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                                     print(result)
                                
                                    if (error == nil){
                                        if let newResult = result as? Dictionary<String,AnyObject>{
                                           self.genricParsing(value: newResult["first_name"], objectToStore: &firstName)
                                           self.genricParsing(value: newResult["id"], objectToStore: &id)
                                           self.genricParsing(value: newResult["last_name"], objectToStore: &lastName)
                                           self.genricParsing(value: newResult["email"], objectToStore: &emailId)
                                           
                                           pictureUrl = self.getProfilePicUrl(object: newResult)
                                            fbDataOnSucess(firstName, lastName, emailId, id, pictureUrl)
                                        }
    //                                    ViewControllerUtils.sharedInstance.hideActivityIndicator(uiView: viewControler.view)
                                        return
                                    }else{
    //                                    ViewControllerUtils.sharedInstance.hideActivityIndicator(uiView: viewControler.view)
                                        onfaLiure(error as! NSError)
                                        return
                                    }
                                })
                            }
                            break
                        case true:
                            break
                        }
                    default:
                        print(error ?? "")
                        break
                    }
                }
//            }
        }
    
    private func genricParsing<T>(value:AnyObject?, objectToStore:inout T){
        print(value)
        if let value = value as? T{
            objectToStore = value
        }
    }
    private func getProfilePicUrl(object: Dictionary<String,AnyObject>) -> String {
        var url = ""
        guard let picture = object["picture"] as? [String: Any]  else {
            return url
        }
        if let data = picture["data"] as? [String: Any] {
            if let value = data["url"] as? String {
                url = value
            }
        }
        print(url)
        return url
    }
}
