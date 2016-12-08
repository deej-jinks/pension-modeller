//
//  LoginScreenViewController.swift
//  DCModeller
//
//  Created by Daniel Jinks on 19/05/2016.
//  Copyright © 2016 Daniel Jinks. All rights reserved.
//

import UIKit
import SpriteKit
import CoreData

class LoginScreenViewController: UIViewController {
    
    @IBOutlet weak var firstCircleLogo: UIImageView!
    
    @IBOutlet weak var execLogoYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sparkle: UIImageView!
    
    @IBOutlet weak var sparkleHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var execLogo: UIImageView! 
    
    @IBOutlet weak var execLogoWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var execLogoXOffset: NSLayoutConstraint!
    
    @IBOutlet weak var execLogoShadow: UIView!
    
    @IBOutlet weak var staticBackround: UIImageView!
    
    @IBOutlet weak var animationLayer: SKView! {
        didSet {
            animationLayer.allowsTransparency = true
        }
    }
    
    @IBOutlet weak var usernameBox: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordBox: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.layer.cornerRadius = loginButton.frame.height / 2
            loginButton.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var rememberMeLabel: UILabel!
    @IBOutlet weak var rememberMeCheckbox: CheckBox!
    
    
    
    @IBOutlet weak var loadingView: UIView! {
        didSet {
            loadingView.alpha = 0.0
            loadingView.layer.cornerRadius = 7.0
            loadingView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    struct Constants {
        static let Username = "admin"
        static let Password = "0x15656ae40"
    }
    
   let dataLoader = DataLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rememberMeCheckbox.isChecked = UserDefaults.standard.bool(forKey: "DCModeller Remember Me")
        addRememberedPasswords()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginScreenViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object:  nil)
        
        self.view.layoutIfNeeded()
        UIView.transition(with: staticBackround, duration: 4.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            self.staticBackround.alpha = 0.0
            }, completion: nil)
        doLogoAnimations()
        setupEmitters()
    }
    
    func updateRememberMe() {
        
        let defaults = UserDefaults.standard
        defaults.set(self.rememberMeCheckbox.isChecked, forKey: "DCModeller Remember Me")
        if rememberMeCheckbox.isChecked {
            defaults.set(self.usernameTextField.text!, forKey: "DCModeller Username")
            defaults.set(self.passwordTextField.text!, forKey: "DCModeller Password")
        } else {
            defaults.set("", forKey: "DCModeller Username")
            defaults.set("", forKey: "DCModeller Password")
        }
    }
    
    func addRememberedPasswords() {
        let defaults = UserDefaults.standard
        if let user = defaults.object(forKey: "DCModeller Username") as? String {
            if user != "" {
                usernameTextField.text = user
            }
        }
        if let pass = defaults.object(forKey: "DCModeller Password") as? String {
            if pass != "" {
                passwordTextField.text = pass
            }
        }
    }
    
    func keyboardWillShow(_ notification: Notification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height + 20
            self.view.layoutIfNeeded()
        }) 
    }
    
    func setupEmitters() {
        
        let height = Double(view.bounds.size.height)
        let width = Double(view.bounds.size.width)
        
        let sceneToPresent = SKScene(size: view.bounds.size)
        sceneToPresent.anchorPoint = CGPoint.zero
        sceneToPresent.name = "Particle Scene"
        sceneToPresent.scaleMode = .resizeFill
        sceneToPresent.backgroundColor = UIColor.clear
        
        
        let sideEmitters = Int(view.frame.height / 100)
        let topEmitters = Int(view.frame.width / 100)
        var emitter: SKEmitterNode?
        
        for i in 0..<sideEmitters {
            
            let fraction = Double(i)/Double(sideEmitters)
            
            emitter = SKEmitterNode(fileNamed: "fasterNumberEmitter.sks")
            switch i % 3 {
                
            case 0: emitter?.particleTexture = SKTexture(imageNamed: "number1.png")
                
            case 1: emitter?.particleTexture = SKTexture(imageNamed: "number4.png")
                
            case 2: emitter?.particleTexture = SKTexture(imageNamed: "number7.png")
                
            default: emitter?.particleTexture = SKTexture(imageNamed: "number0.png")
            }
            
            emitter!.position = CGPoint(x: CGFloat(50 - 200 * fraction ), y: CGFloat(height - (height * fraction) ) );
            
            sceneToPresent.addChild(emitter!)
        }
        
        for i in 0..<topEmitters {
            
            let fraction = Double(i)/Double(topEmitters)
            
            emitter = SKEmitterNode(fileNamed: "fasterNumberEmitter.sks")
            
            switch i % 3 {
                
            case 0: emitter?.particleTexture = SKTexture(imageNamed: "number1.png")
                
            case 1: emitter?.particleTexture = SKTexture(imageNamed: "number4.png")
                
            case 2: emitter?.particleTexture = SKTexture(imageNamed: "number7.png")
                
            default: emitter?.particleTexture = SKTexture(imageNamed: "number0.png")
            }
            
            emitter!.position = CGPoint(x: CGFloat(width * fraction), y: CGFloat(height - 50 + 200 * fraction));
            
            sceneToPresent.addChild(emitter!)
        }
        
        
        animationLayer.presentScene(sceneToPresent)
    }
    
    func doLogoAnimations() {
        //bring in circle
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, delay: 0.2, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            
            self.execLogoYConstraint.constant = 0.0
            self.view.layoutIfNeeded()
            
            }, completion: nil)
        
        //bring in exec logo
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.8, delay: 0.7, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            self.execLogo.alpha = 1.0
            self.execLogoXOffset.constant = 0.0
            self.execLogoWidthConstraint.constant = 89.0
            self.execLogoShadow.alpha = 0.25
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        //twinkle grow
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 1.7, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            
            self.sparkleHeightConstraint.constant = 50.0
            self.view.layoutIfNeeded()
            
            }, completion: nil)
        
        //twinkle shrink
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 2.0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            
            self.sparkleHeightConstraint.constant = 25.0
            self.view.layoutIfNeeded()
            
            }, completion: nil)
    }
    
    @IBAction func loginAttempt(_ sender: UIButton) {
        
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        if passwordTextField.text?.lowercased() == Constants.Password {
            
            //check for user record
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            request.predicate = NSPredicate(format: "name == %@", (usernameTextField.text?.lowercased())!)
            do {
                let result = try AppDelegate.getContext().fetch(request) as! [User]
                if let existingUser = result.first {
                    print("user record found : \(existingUser)")
                    print("user has accepted TsCs : \(Bool(existingUser.acceptedTsCs!))")
                    //print("user has accepted TsCs : \(Bool(currentUser!.acceptedTsCs!))")
                    currentUser = existingUser
                    currentDCPension = existingUser.dcPension
                } else {
                    print("user record not found")
                    createNewUserRecord((usernameTextField.text?.lowercased())!)
                    createNewDCPensionRecord((usernameTextField.text?.lowercased())!)
                }
                
            } catch {}
            
//            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)) {
                self.dataLoader.clearAnnuityData()
                self.dataLoader.parseAndAddData()
                annuitiesUpdated = true
//            }
            
            //AppDelegate.getDelegate().saveContext()
            
            self.performSegue(withIdentifier: "LoginSegue", sender: self)
            
            updateRememberMe()
            
        } else {
            let alert = UIAlertView()
            alert.title = "Incorrect username and password combination"
            alert.message = "Please enter a correct username and password combination."
            alert.addButton(withTitle: "OK")
            alert.show()
        }
        
    }
    


            

    
    func createNewUserRecord(_ name: String) {
        let request = NSEntityDescription.insertNewObject(forEntityName: "User", into: AppDelegate.getContext()) as! User
        print("inserting user, name : \(name)")
        request.name = name
        request.dateOfBirth = nil
        request.isMale = nil
        request.salary = nil
        request.priceInflation = 0.025
        request.salaryInflation = 0.025
        request.acceptedTsCs = false
        //request.dcPension = mainDCPension
        currentUser = request
    }
    
    func createNewDCPensionRecord(_ name: String) {
        let request = NSEntityDescription.insertNewObject(forEntityName: "DCPension", into: AppDelegate.getContext()) as! DCPension
        print("inserting dcpension, name : \(name)")
        request.name = name
        request.currentFundValue = nil
        request.investmentReturnsPreRetirement = 0.05
        request.totalContributionRate = 0.0
        request.memberContributionRate = 0.0
        request.employerContributionRate = 0.0
        request.annuitySpouseProportion = 0.5
        request.incomeInflationaryIncreases = true
        request.cashProportion = 0.25
        request.initialDrawdownIncome = nil //??
        request.selectedRetirementAge = nil
        request.investmentReturnInDrawdown = 0.03
        request.niPayoverProportion = 0.0
        request.paymentMethod = GlobalConstants.DCPaymentMethods.ReliefAtSource
        print("about to link, name : \(name)")
        request.user = currentUser!
        print("linked, name : \(name)")
        currentDCPension = request
    }


}
