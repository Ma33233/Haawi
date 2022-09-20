//
//  ResetViewController.swift
//  FinalProject
//
//  Created by AlenaziHazal on 16/02/1444 AH.
//

import UIKit
import FirebaseAuth

class ResetViewController: UIViewController {
    @IBOutlet weak var TipsOptional: UILabel!
    
    @IBOutlet weak var sendRequstBtn: UIButton!
    @IBOutlet weak var resetView: UIView!
    @IBOutlet weak var labelErorrDisplay: UILabel!
    @IBOutlet weak var emailTextEnter: UITextField!
    @IBOutlet weak var labelEmail: UILabel!
    
    let dbAuthRef = Auth.auth()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
        resetView.layer.cornerRadius = 16
        sendRequstBtn.layer.cornerRadius = 20

        
    }
    @IBAction func resetButten(_ sender: Any) {
        sendingPassReset()
    }
    
    func setupElements(){
        // Hide the error label
        labelErorrDisplay.alpha = 0
        labelErorrDisplay.textColor = .red
        
        // Styling elements
        Utilities.styleTextField(emailTextEnter)
    }
    
    func sendingPassReset(){
        //        // Validates fields is in the way we want.
               let checking =  validateFields()
                guard checking == nil else {
                    showError(checking!)
                    return
                }
                
        //         User Login
        dbAuthRef.sendPasswordReset(withEmail: emailTextEnter.text!) { error in
                    // check if there is an error creating the user
                    guard error == nil else{
                        self.showError("Email is invaild")
                        return
                    }
                         }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "login")
        vc!.modalPresentationStyle = .fullScreen
        vc!.modalTransitionStyle = .coverVertical
        self.present(vc!, animated: true)
                
    }
    
    func validateFields() -> String?{
        guard emailTextEnter.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" else{
            return "Please fill in email field"
        }
       return nil
    }
    
    func showError(_ msg: String){
    labelErorrDisplay.text = msg
    labelErorrDisplay.alpha = 1
}
    

}


