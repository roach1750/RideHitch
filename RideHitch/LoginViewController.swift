//
//  LoginViewController.swift
//  RideHitch
//
//  Created by Andrew Roach on 12/27/16.
//  Copyright © 2016 Andrew Roach. All rights reserved.
//

import UIKit
import AWSMobileHubHelper
import AWSCognitoIdentityProvider
import FBSDKLoginKit
import SwiftyJSON

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, AWSCognitoIdentityInteractiveAuthenticationDelegate, AWSCognitoIdentityPasswordAuthentication, AWSCognitoUserPoolsSignInHandler  {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    
    var pool: AWSCognitoIdentityUserPool?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        self.pool = AWSCognitoIdentityUserPool.init(forKey: AWSCognitoUserPoolsSignInProviderKey)
        
        login()
        
    }
    
    @IBAction func infoPressed(_ sender: UIButton) {
        
        print((self.pool?.getUser("Andrew_Roach_10207801610258024").isSignedIn)! as Bool)
    }
    
    
    func login() {
        
        if FBSDKAccessToken.current() != nil {
            fetchFacebookUser()
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        print("Login done with result: \(result) and error: \(error)")
        login()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        print("User Logged Out")
        
    }
    
    
    
    func fetchFacebookUser() {
        
        let RI = RealmInteractor()
        
        //In the future make this check if the users account exists.
        
        if RI.fetchUser() != nil {
            print("attempting to login AWS User")
            loginToAWS()
        }
        else {
            FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, id, email, picture.type(large)"]).start { (connection, result, error) in
                
                if result != nil {
                    let resultsJSON = JSON(result!).dictionaryValue
                    let userId = resultsJSON["id"]?.rawString()
                    
                    let realmUser = User()
                    realmUser.email = (resultsJSON["email"]?.rawString())!
                    realmUser.givenName = (resultsJSON["first_name"]?.rawString())!
                    realmUser.surName = (resultsJSON["last_name"]?.rawString())!
                    realmUser.userName = realmUser.email + "_" + userId!
                    realmUser.password = userId!
                    RI.saveUser(user: realmUser)
                    self.fetchFacebookUser()
                }
            }
        }
    }
    
    
    
    func createAWSUser(){
        
        let RI = RealmInteractor()
        if let possibleUser = RI.fetchUser() {
            
            var attributes = [AWSCognitoIdentityUserAttributeType]()
            
            let email = AWSCognitoIdentityUserAttributeType()
            email?.name = "email"
            email?.value = possibleUser.email
            attributes.append(email!)
            
            
            self.pool?.signUp(possibleUser.userName, password: possibleUser.password, userAttributes: attributes, validationData: nil).continue({ (task: AWSTask) -> Any? in
                
                if let error = task.error {
                    
                    let errorMessage = (error as NSError).userInfo["message"]! as! String
                    
                    if errorMessage == "User already exists" {
                        self.loginToAWS()
                    }
                    
                    
                    
                }
                else {
                    print("created new user!")
                }
                return nil
            }, cancellationToken: nil)
        }
    }
    
    
    //Login to as existing User
    
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AnyObject>?
    
    
    func loginToAWS() {
        
        AWSCognitoUserPoolsSignInProvider.sharedInstance().setInteractiveAuthDelegate(self)
        self.handleLoginWithSignInProvider(signInProvider: AWSCognitoUserPoolsSignInProvider.sharedInstance())
    }
    
    func handleLoginWithSignInProvider(signInProvider: AWSSignInProvider) {
        
        AWSIdentityManager.defaultIdentityManager().loginWithSign(signInProvider) { (result, error) in
            if error == nil {
                print("result = \(result), error = \(error)")
            }
        }
    }
    
    
    
    
    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
        return self
    }
    
    public func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource as? AWSTaskCompletionSource<AnyObject>
        
    }
    
    
    func handleUserPoolSignInFlowStart() {
        // check if both username and password fields are provided
        let RI = RealmInteractor()
        if let possibleUser = RI.fetchUser() {
            // set the task completion result as an object of AWSCognitoIdentityPasswordAuthenticationDetails with username and password that the app user provides
            self.passwordAuthenticationCompletion?.setResult(AWSCognitoIdentityPasswordAuthenticationDetails(username: possibleUser.userName, password: possibleUser.password))
            
        }
        
        
    }
    
    
    ///not sure which one of these are required

    
    func didCompleteStepWithError(_ error: Error?) {
        self.performSegue(withIdentifier: "continueSegue", sender: self)
                
        print("error")
    }
    
    
    
    
    
}
