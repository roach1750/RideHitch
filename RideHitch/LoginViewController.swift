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

class LoginViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    let facebookLoginButton = UIButton()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        AWSFacebookSignInProvider.sharedInstance().setPermissions(["public_profile"]);
        
        facebookLoginButton.addTarget(self, action: #selector(LoginViewController.handleFacebookLogin), for: .touchUpInside)
        let facebookButtonImage: UIImage? = UIImage(named: "FacebookButton")
        if let facebookButtonImage = facebookButtonImage{
            facebookLoginButton.setImage(facebookButtonImage, for: .normal)
        } else {
            print("Facebook button image unavailable. We're hiding this button.")
            facebookLoginButton.isHidden = true
        }
        
        facebookLoginButton.frame.size = CGSize(width: 200, height: 100)
        facebookLoginButton.center  = CGPoint(x: self.view.center.x, y: self.view.center.y + 150)
        
        updateUI()
        view.addSubview(facebookLoginButton)
        
    }
    
    
    func handleLoginWithSignInProvider(signInProvider: AWSSignInProvider) {
        AWSIdentityManager.defaultIdentityManager().loginWithSign(signInProvider) { (result, error) in
            if error == nil {
//                print("result = \(result), error = \(error)")
                print(AWSIdentityManager.defaultIdentityManager().identityId!)
                
                
                self.updateUI()
            }
        }
    }
    
    func updateUI(){
        let identityManager = AWSIdentityManager.defaultIdentityManager()
        
        if let identityUserName = identityManager.userName {
            nameLabel.text = identityUserName
        } else {
            nameLabel.text = NSLocalizedString("Guest User", comment: "Placeholder text for the guest user.")
        }
        
//        userID.text = identityManager.identityId
        if let imageURL = identityManager.imageURL {
            let imageData = NSData(contentsOf: imageURL)!
            if let profileImage = UIImage(data: imageData as Data) {
                pictureImageView.image = profileImage
            } else {
                pictureImageView.image = UIImage(named: "UserIcon")
            }
        }
    }
    
    func handleFacebookLogin() {
        // Facebook login permissions can be optionally set, but must be set
        // before user authenticates.
        if AWSIdentityManager.defaultIdentityManager().isLoggedIn {
            handleLogout()
        }
        else {
            AWSFacebookSignInProvider.sharedInstance().setPermissions(["public_profile"]);
            handleLoginWithSignInProvider(signInProvider: AWSFacebookSignInProvider.sharedInstance())
        }
    }
    
    
    //logOut:
    
    func handleLogout() {
        if AWSIdentityManager.defaultIdentityManager().isLoggedIn {
            AWSIdentityManager.defaultIdentityManager().logout(completionHandler: { (result, error) in
                print("Logout Successful: \(result)");
                self.updateUI()
            })
        }
        else {
            assert(false)
        }
    }
    
}
