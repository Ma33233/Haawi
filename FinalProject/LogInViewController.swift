//
//  ViewController.swift
//  FinalProject
//
//  Created by Maan Abdullah on 11/09/2022.
//

import UIKit
import FirebaseAuth
class LogInViewController: UIViewController {
    @IBOutlet weak var noteForLogoOrAppName: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var labelForSginUp: UILabel!
    @IBOutlet weak var labelForForgetPassword: UILabel!
    @IBOutlet weak var labelErorrDisplay: UILabel!
    @IBOutlet weak var labelForPasswordEnter: UILabel!
    @IBOutlet weak var labelForEmailEnter: UILabel!
    @IBOutlet weak var passwordTextEnter: UITextField!
    @IBOutlet weak var emailTextEnter: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    var isPasswordChanged = false
    var msgFromScene = ""
    let userDefault = UserDefaults.standard
    let dbAuthRef = Auth.auth()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        if isPasswordChanged{
            labelErorrDisplay.text = showPasswordError(msgFromScene)
        }
    }


    @IBAction func logInButten(_ sender: Any) {
        login()
    }
    @IBAction func forgetPasswordButten(_ sender: Any) {
        performSegue(withIdentifier: "forgetPassword", sender: nil)
    }
    @IBAction func sginUpButten(_ sender: Any) {
        performSegue(withIdentifier: "sginUp", sender: nil)
    }
    @IBAction func backOrDismiss(segue: UIStoryboardSegue) {
        
    }
    
    func setupElements(){
        // Hide the error label
        labelErorrDisplay.alpha = 0
        labelErorrDisplay.textColor = .red
        
        // Styling elements
        Utilities.styleTextField(emailTextEnter)
        Utilities.styleTextField(passwordTextEnter)
    }
    
    func login(){
        //        // Validates fields is in the way we want.
               let checking =  validateFields()
                guard checking == nil else {
                    showError(checking!)
                    return
                }
                
        //         User Login
        dbAuthRef.signIn(withEmail: emailTextEnter.text!, password: passwordTextEnter.text!) { result, error in
                    // check if there is an error creating the user
                    guard error == nil else{
                        self.showError("Email/Password is invaild")
                        return
                    }
            self.userDefault.set((self.emailTextEnter.text?.trimmingCharacters(in: .whitespacesAndNewlines))!, forKey: "email")
            self.userDefault.set(self.passwordTextEnter.text?.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "password")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
            vc!.modalPresentationStyle = .fullScreen
            vc!.modalTransitionStyle = .coverVertical
            self.present(vc!, animated: true)
                         }
        

                
    }
    
    func validateFields() -> String?{
        guard emailTextEnter.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" &&  passwordTextEnter.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            return "Please fill in all the fields"
        }
        guard Utilities.isEmailValid(emailTextEnter.text!) == true else{
            return "Invalid email"
        }
       return nil
    }
    
    func showError(_ msg: String){
    labelErorrDisplay.text = msg
    labelErorrDisplay.alpha = 1
}
    
    func passwordChanged(_ msg: String){
        isPasswordChanged = true
        msgFromScene = msg
    }
    func showPasswordError(_ msg: String) -> String{
        labelErorrDisplay.textColor = .red
        labelErorrDisplay.alpha = 1
        return msg
    }
    

}
