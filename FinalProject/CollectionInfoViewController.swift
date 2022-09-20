//
//  CollectionInfoViewController.swift
//  FinalProject
//
//  Created by Faisal Almutairi on 18/02/1444 AH.
//

import UIKit
import CoreLocation

class CollectionInfoViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var goToMapBtn: UIButton!
        
    @IBOutlet weak var personName: UIButton!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var desTextView: UITextView!
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var categoryImage: UIImageView!
    
    var sesstion: Session? = nil
    var sessionLocation: CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .blue
        desTextView.layer.cornerRadius = 16
        goToMapBtn.layer.cornerRadius = 10
        personImage.layer.borderWidth = 1
        personImage.layer.masksToBounds = false
        personImage.layer.borderColor = UIColor.darkGray.cgColor
        personImage.layer.cornerRadius = personImage.frame.height/2
        personImage.clipsToBounds = true
        titleLabel.text =  sesstion!.title
        personName.setTitle(sesstion!.userName, for: .normal)
        if let userImage = sesstion?.userPicture{
            personImage.image = UIImage(data: userImage)
        }
        else{
            personImage.image = UIImage(systemName: "person.circle")
        }
        if let info = sesstion?.description{
            desTextView.text = info
        }
        else{
            desTextView.text = "لم يقم صاحب الجلسة بإضافة تفاصيل عن هذه الجلسة"
        }
        category.text = sesstion!.category
        sessionLocation = CLLocationCoordinate2D(latitude: sesstion!.lat!, longitude: sesstion!.long!)
//        fetchSesstionData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .blue

    }
    @IBAction func goToMapBtn(_ sender: Any) {
    
            if sessionLocation != nil{
           if (UIApplication.shared.canOpenURL(NSURL(string:"https://maps.google.com/%22")! as URL))
                {
               UIApplication.shared.open(NSURL(string:
                                                "https://www.google.co.in/maps/dir/?saddr=&daddr=\(sessionLocation!.latitude),\(sessionLocation!.longitude)&directionsmode=driving")! as URL)
                }}
    }
    
//    func fetchSesstionData(){
//        if let sesstionID = sesstionID {
//            DatabaseManager.shared.fireStore.collection("Sessions").document(sesstionID).getDocument{
//                result, error in
//
//                guard error == nil else{
//                    let alert = UIAlertController(title: "حدثت مشكلكة", message: "حدثت مشكلة اثناء جلب البيانات، تأكد إنك متصل بالإنترنت ثم حاول مرة أخرى", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "فهمت", style: .default) {_ in
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
//                        let nav = UINavigationController(rootViewController: vc!)
//                        nav.modalPresentationStyle = .fullScreen
//                        self.present(nav, animated: true)
//                    })
//                    self.present(alert, animated: true, completion: nil)
//                    return
//                }
//                let userID = result?.get("userID") as! String
//                DatabaseManager.shared.fireStore.collection("Users").document(userID).getDocument{ query, error in
//                    guard error == nil else{
//                        let alert = UIAlertController(title: "حدثت مشكلكة", message: "حدثت مشكلة اثناء جلب البيانات، تأكد إنك متصل بالإنترنت ثم حاول مرة أخرى", preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "فهمت", style: .default) {_ in
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
//                            let nav = UINavigationController(rootViewController: vc!)
//                            nav.modalPresentationStyle = .fullScreen
//                            self.present(nav, animated: true)
//                        })
//                        self.present(alert, animated: true, completion: nil)
//                        return
//                    }
//                self.getUserPicture(id: userID){ data in
//                    if let data = data {
//                        self.personImage.image = UIImage(data: data)
//                    }
//                    else{
//                        self.personImage.image = UIImage(systemName: "person.circle")
//                    }
//                    self.personName.text = (query?.get("userName") as! String)
//                    self.titleLabel.text = (result?.get("title") as! String)
//                    if let des = result?.get("description") as? String{
//                        self.desTextView.text = des
//                    }
//                    else{}
//                    self.category.text = (result?.get("category") as! String)
//                    let latitude = result?.get("lat") as! Double
//                    let longitude = result?.get("long") as! Double
//                    self.sessionLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//
//                }
//
//            }
//        }
//
//    }
//    }
//    func getUserPicture(id: String, completion: @escaping(Data?)->Void){
//
//        DatabaseManager.shared.storageRef.reference().child("\(id).jpeg").downloadURL { url, error in
//            guard error == nil else{
//                print(error!.localizedDescription)
//                completion(nil)
//                return
//            }
//            let data = try! Data(contentsOf: url!)
//            completion(data)
//        }
//    }
    
    @IBAction func goToUserProfile(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "userProfile") as! ProfileViewController
        vc.shownUserID = sesstion!.userID
        navigationController!.modalPresentationStyle = .fullScreen
        navigationController!.pushViewController(vc, animated: true)

    }
}
