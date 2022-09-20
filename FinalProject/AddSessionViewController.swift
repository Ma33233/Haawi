//
//  AddSessionViewController.swift
//  FinalProject
//
//  Created by Faisal Almutairi on 18/02/1444 AH.
//

import UIKit
import CoreLocation
class AddSessionViewController: UIViewController {
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var timesSegmented: UISegmentedControl!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    
    let categoryList = ["طبي","تقني","فني","هندسي","رياضي"]
    var categoryPickerView = UIPickerView()
    let db = DatabaseManager.shared.fireStore
    let auth = DatabaseManager.shared.authRef
    let Manager = CLLocationManager()
    var userLocation: CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTextField.inputView = categoryPickerView
        categoryTextField.placeholder = "اختر الفئة"
        categoryTextField.textAlignment = .center
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        view1.layer.cornerRadius = 16
        view2.layer.cornerRadius = 16
        detailsTextView.layer.cornerRadius = 16
        Manager.startUpdatingLocation()
        userLocation = Manager.location?.coordinate
    }
    
    
    
    
    @IBAction func addSessionBtn(_ sender: Any) {
        
        let title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        //        let titleDetails = detailsTextView.text
        let category = categoryTextField.text
        
        
        guard category != "" else {
            print("you didn't write the category")
            
            let popup = UIAlertController(title: "تحذير", message: "من فضلك ادخل الفئة", preferredStyle: .alert)
            let action = UIAlertAction(title: "تم", style: .default)
            popup.addAction(action)
            self.present(popup, animated: true, completion: nil)
            return
        }
        
        
        guard title != "" else {
            print("you didn't write the title")
            
            let popup = UIAlertController(title: "تحذير", message: "من فضلك ادخل عنوان الجلسة", preferredStyle: .alert)
            let action = UIAlertAction(title: "تم", style: .default)
            popup.addAction(action)
            self.present(popup, animated: true, completion: nil)
            return
        }
        
        Manager.startUpdatingLocation()
        userLocation = Manager.location?.coordinate
        
        guard userLocation != nil else{
            let popup = UIAlertController(title: "تحذير", message: "من فضلك أسمح للتطبيق لموقع الحالي لإضافة الجلسة", preferredStyle: .alert)
            let action = UIAlertAction(title: "تم", style: .default)
            popup.addAction(action)
            self.present(popup, animated: true, completion: nil)
            return
        }
        
        checkIfTheyHaveOpenSession(){ theyHave in
            if theyHave{
                let popup = UIAlertController(title: "عذرًا", message: "لا يمكنك انشاء جلسة جديدة، لديك واحدة مفتوحة بالفعل", preferredStyle: .alert)
                let action = UIAlertAction(title: "تم", style: .default)
                popup.addAction(action)
                self.present(popup, animated: true, completion: nil)
            }
            else{
                let popup = UIAlertController(title: "تم اضافة جلسة", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "تم", style: .default){_ in
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    let nav = UINavigationController(rootViewController: vc!)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true)
                    
                }
                popup.addAction(action)
                self.present(popup, animated: true, completion: nil)
                self.saveData()
            }
            
        }
        
        
    }
    
    
    func saveData(){
        let documentId = UUID()
        
        db.collection("Sessions").document("\(documentId)").setData([
            
            "title" : titleTextField.text!,
            //                "category" : "\(categoryList[pickerView.selectedRow(inComponent: 0)])",
            "category" : categoryTextField.text!,
            "details" : detailsTextView.text!,
            "lat" : userLocation!.latitude,
            "long" : userLocation!.longitude,
            "userID" : auth.currentUser!.uid,
            "sesstionID" : "\(documentId)",
            "isClosed" : false,
            "date" : Date().formatted(),
            "timeInterval": Date.timeIntervalSinceReferenceDate
        ])
        { error in
            
            if let e = error {
                print(e.localizedDescription)
            }else{
                print("done")
            }
        }
    }
    
    func checkIfTheyHaveOpenSession(completion: @escaping ((Bool) -> Void)){
        db.collection("Sessions").whereField("userID", isEqualTo: auth.currentUser!.uid).getDocuments{
            query, error in
            guard error == nil else{
                let popup = UIAlertController(title: "حدث خطأ", message: "حدث خطأ إثناء الاتصال بالسيرفر، حاول مرة أخرى من فضلك", preferredStyle: .alert)
                let action = UIAlertAction(title: "تم", style: .default)
                popup.addAction(action)
                self.present(popup, animated: true, completion: nil)
                return
            }
            guard let queries = query?.documents else{
                completion(false)
                return
            }
            print(queries.count)
            for doc in queries{
                print("something")
                if let isClosed = doc.get("isClosed") as? Bool{
                    guard isClosed == true else{
                    completion(true)
                        return
                }}
            }
            completion(false)
        }
        }
    }





extension AddSessionViewController : UIPickerViewDelegate , UIPickerViewDataSource {
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        categoryTextField.text = categoryList[row]
        categoryTextField.resignFirstResponder()
    }
}
