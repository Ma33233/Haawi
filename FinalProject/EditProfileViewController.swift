//
//  EditProfileViewController.swift
//  FinalProject
//
//  Created by Faisal Almutairi on 18/02/1444 AH.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var saveProfileBtn: UIButton!
    let userID = DatabaseManager.shared.authRef.currentUser!.uid
    var userNewImage: UIImage!
    var imageChanged = false
    override func viewDidLoad() {
        super.viewDidLoad()
        saveProfileBtn.layer.cornerRadius = 16
        editView.layer.cornerRadius = 16
        bioTextView.layer.cornerRadius = 16
        
        if UserDefaults.standard.object(forKey: "\(userID)firstName") == nil ||
            UserDefaults.standard.object(forKey: "\(userID)lastName") == nil ||
            UserDefaults.standard.object(forKey: "\(userID)bio") == nil{
            fetchUserData()
        }
        else{
            firstNameTextField.text = (UserDefaults.standard.object(forKey: "\(userID)firstName") as! String)
            lastNameTextField.text =  (UserDefaults.standard.object(forKey: "\(userID)lastName") as! String)
            bioTextView.text = (UserDefaults.standard.object(forKey: "\(userID)bio") as! String)
        }
    }
    
    
    func fetchUserData(){
        DatabaseManager.shared.fireStore.collection("Users").document(userID).getDocument{
            result, error in
            guard error == nil else{
                let popup = UIAlertController(title: "خطأ", message: "حدث خطأ، حاول مرة أخرى", preferredStyle: .alert)
                let action = UIAlertAction(title: "تم", style: .default)
                popup.addAction(action)
                self.present(popup, animated: true, completion: nil)
                return
            }
            if let userInfo = result?.data(){
                if let firstName = userInfo["firstName"]{
                    if let firstName = firstName as? String{
                        self.firstNameTextField.text = firstName
                        UserDefaults.standard.set(firstName, forKey: "\(self.userID)firstName")
                    }
                }
                if let lastName = userInfo["lastName"]{
                    if let lastName = lastName as? String{
                        self.lastNameTextField.text = lastName
                        UserDefaults.standard.set(lastName, forKey: "\(self.userID)lastName")
                    }
                }
                if let bio = userInfo["bio"]{
                    if let bio = bio as? String{
                        self.bioTextView.text = bio
                        UserDefaults.standard.set(bio, forKey: "\(self.userID)Bio")
                    }
                }
            }
        }
    }
    
    func updateData(){
        if firstNameTextField.text?.rangeOfCharacter(from: .decimalDigits) == nil && lastNameTextField.text?.rangeOfCharacter(from: .decimalDigits) == nil &&
            firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false && lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
            DatabaseManager.shared.fireStore.collection("Users").document(userID).updateData(["firstName" : firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                                                                              "lastName" : lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines),
                                                                                              "bio" : bioTextView.text.trimmingCharacters(in: .whitespaces)]){
                error in
                guard error == nil else{
                    let popup = UIAlertController(title: "خطأ", message: "حدث خطأ، حاول مرة أخرى", preferredStyle: .alert)
                    let action = UIAlertAction(title: "تم", style: .default)
                    popup.addAction(action)
                    self.present(popup, animated: true, completion: nil)
                    return
                }
                UserDefaults.standard.set(self.firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "\(self.userID)firstName")
                UserDefaults.standard.set(self.lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "\(self.userID)lastName")
                UserDefaults.standard.set(self.bioTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "\(self.userID)bio")
                
            }
        }
        else if firstNameTextField.text?.rangeOfCharacter(from: .decimalDigits) == nil && firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false{
            DatabaseManager.shared.fireStore.collection("Users").document(userID).updateData(["firstName" : firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)]){
                error in
                guard error == nil else{
                    let popup = UIAlertController(title: "خطأ", message: "حدث خطأ، حاول مرة أخرى", preferredStyle: .alert)
                    let action = UIAlertAction(title: "تم", style: .default)
                    popup.addAction(action)
                    self.present(popup, animated: true, completion: nil)
                    return
                }
                UserDefaults.standard.set(self.firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "\(self.userID)firstName")
            }}
        else if lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false && firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
            let popup = UIAlertController(title: "خطأ", message: "لا يمكنك ادخال الاسم الاخير فقط دون ادخال الاسم الاول", preferredStyle: .alert)
            let action = UIAlertAction(title: "فهمت", style: .default)
            popup.addAction(action)
            self.present(popup, animated: true, completion: nil)
        }
        else if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true && lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
            let popup = UIAlertController(title: "خطأ", message: "يجب ادخال الإسم الأول على الأقل", preferredStyle: .alert)
            let action = UIAlertAction(title: "فهمت", style: .default)
            popup.addAction(action)
            self.present(popup, animated: true, completion: nil)
        }
        else{
            let popup = UIAlertController(title: "خطأ", message: "يجب ادخال احرف فقط للإسم الأول والأخير", preferredStyle: .alert)
            let action = UIAlertAction(title: "فهمت", style: .default)
            popup.addAction(action)
            self.present(popup, animated: true, completion: nil)
        }
    }
    
    @IBAction func backToProfilePressed(_ sender: Any) {
        performSegue(withIdentifier: "backToProfile", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "backToProfile" else{
            print("error")
            return
        }
        guard let dis = segue.destination as? ProfileViewController else{
            print("error2")
            return
        }
        dis.didImgChanged = imageChanged
    }
    func editPicture(){
            let imageData = userNewImage?.jpegData(compressionQuality: 0.5)
            guard imageData != nil else{
                let popup = UIAlertController(title: "خطأ", message: "حدث خطأ اثناء رفع الصورة، حاول مرة اخرى", preferredStyle: .alert)
                let action = UIAlertAction(title: "تم", style: .default)
                popup.addAction(action)
                self.present(popup, animated: true, completion: nil)
                return
            }
            
        DatabaseManager.shared.storageRef.reference().child("\(userID).jpeg").putData(imageData!) { result, error in
            guard error == nil else{
            let popup = UIAlertController(title: "خطأ", message: "حدث خطأ اثناء رفع الصورة، حاول مرة اخرى", preferredStyle: .alert)
            let action = UIAlertAction(title: "تم", style: .default)
            popup.addAction(action)
            self.present(popup, animated: true, completion: nil)
                    return
                }
            let popup = UIAlertController(title: "تم بنجاح", message: "تم بنجاح تغيير الصورة", preferredStyle: .alert)
            let action = UIAlertAction(title: "تم", style: .default)
            popup.addAction(action)
            self.present(popup, animated: true, completion: nil)
            self.imageChanged = true
            }
    }
    @IBAction func saveProfileBtn(_ sender: Any) {
        updateData()
        print("ddd")
    }
    @IBAction func editPicPtn(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true)
        }
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        userNewImage = image
        self.dismiss(animated: true)
        editPicture()

    }
}
