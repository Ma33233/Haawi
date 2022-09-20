//
//  ProfileViewController.swift
//  FinalProject
//
//  Created by AlenaziHazal on 17/02/1444 AH.
//

import UIKit
import FirebaseFirestore
class ProfileViewController: UIViewController {
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var viewContener: UIView!
    @IBOutlet weak var numberOfSesstions: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var EditProfileBtn: UIButton!
    @IBOutlet weak var editingProfileBtn: UIButton!
    @IBOutlet weak var followingUsersNum: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var followView: UIView!
    @IBOutlet weak var presentBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    
    var shownUserID: String?
    var userID: String?
    var followingUsers: [String] = []
    let userDefault = UserDefaults.standard
    var sesstions: [userSession] = []
    var didImgChanged: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backItem?.title = "العودة"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "profileTableViewCell", bundle: nil), forCellReuseIdentifier: "tableCell")
        profileView.layer.cornerRadius = 32
        tableView.layer.cornerRadius = 16
        followView.layer.cornerRadius = 16
        EditProfileBtn.layer.cornerRadius = 16
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.darkGray.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
//        if sesstions.count == 0 {
//            tableView.isHidden = true
//            let imgError = UIImageView(frame: CGRect(x: 135, y: 530, width: 150, height: 150))
//            imgError.image = UIImage(systemName: "xmark.circle")
//            imgError.tintColor = .lightGray
//            
//            self.view.addSubview(imgError)
//            
//            let textLabel = UILabel(frame: CGRect(x: 120, y: 690 , width: 200, height: 40))
//            
//            textLabel.text = "لا يوجد لديك جلسة سابقة"
//            textLabel.textAlignment = .center
//            textLabel.textColor = .lightGray
//            self.view.addSubview(textLabel)
//            
//        }
        
        
        if shownUserID == nil{
            followBtn.isEnabled = false
            followBtn.isHidden = true
            if let userid = DatabaseManager.shared.authRef.currentUser?.uid{
                userID = userid
                if userDefault.object(forKey: "userName") == nil || userDefault.object(forKey: "userPicture") == nil ||
                    userDefault.object(forKey: "\(DatabaseManager.shared.authRef.currentUser!.uid)followingUsers") == nil ||
                    userDefault.object(forKey: "numberOfSesstions") == nil {
                    fetchUserData(id: userID!)
                }
            }
        }else{
            logoutBtn.isEnabled = false
            logoutBtn.isHidden = true
            editingProfileBtn.isEnabled = false
            editingProfileBtn.isHidden = true
            if let followingUsers =  userDefault.object(forKey: "\(DatabaseManager.shared.authRef.currentUser!.uid)followingUsers") as? [String]{
                if followingUsers.contains(where: { userid in
                    userid == shownUserID
                }){
                    followBtn.backgroundColor = .red
                    followBtn.setTitle("unfollow", for: .normal)
                    followBtn.addTarget(self, action: #selector(unFollowBtnPressed), for: .touchUpInside)
                }
                else{
                    followBtn.backgroundColor = .green
                    followBtn.setTitle("follow", for: .normal)
                    followBtn.addTarget(self, action: #selector(followBtnPressed), for: .touchUpInside)
                    
                }
                
                fetchUserData(id: shownUserID!)
            }
            else{
                self.fetchFollowingUsers{ fetched in
                    if fetched != nil{
                        if self.followingUsers.contains(where: { userid in
                            userid == self.shownUserID
                        }){
                            self.followBtn.backgroundColor = .red
                            self.followBtn.setTitle("unfollow", for: .normal)
                            self.followBtn.addTarget(self, action: #selector(self.unFollowBtnPressed), for: .touchUpInside)
                        }
                        else{
                            self.followBtn.backgroundColor = .green
                            self.followBtn.setTitle("follow", for: .normal)
                            self.followBtn.addTarget(self, action: #selector(self.followBtnPressed), for: .touchUpInside)
                            
                        }
                        self.fetchUserData(id: self.shownUserID!)
                        
                        }
            }
            
            
        }
        
    }
    
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if didImgChanged{
//            print("ddd")
//            getUserPicture(id: DatabaseManager.shared.authRef.currentUser!.uid){ data in
//                if data != nil{
//                    self.profileImage.image = UIImage(data: data!)
//            }
//            }
//        }
//        print(didImgChanged)
//    }
    @IBAction func editProfile(_ sender: Any) {
        performSegue(withIdentifier: "ShortReview", sender: nil)
    }
    
    @IBAction func logOutButten(_ sender: Any) {
    }
    
    @IBAction func shortReviewBio(_ sender: Any) {
        performSegue(withIdentifier: "moreInfo", sender: nil)
    }
    
    @IBAction func BackProfile(segue: UIStoryboardSegue) {
        if didImgChanged{
                    print("ddd")
                    getUserPicture(id: DatabaseManager.shared.authRef.currentUser!.uid){ data in
                        if data != nil{
                            self.profileImage.image = UIImage(data: data!)
                    }
    }
        }
    }
    @objc func followBtnPressed(){
        if let userid = DatabaseManager.shared.authRef.currentUser?.uid{
            DatabaseManager.shared.fireStore.collection("Users").document(userid).updateData(["followingUsers" : FieldValue.arrayUnion([shownUserID!])]) { error in
                guard error == nil else{
                    let popup = UIAlertController(title: "حدث خطأ", message: "حدث خطأ إثناء الاتصال بالسيرفر، حاول مرة أخرى من فضلك", preferredStyle: .alert)
                    let action = UIAlertAction(title: "تم", style: .default)
                    popup.addAction(action)
                    self.present(popup, animated: true, completion: nil)
                    return
                }
                self.followBtn.backgroundColor = .red
                self.followBtn.setTitle("unfollow", for: .normal)
                self.followBtn.addTarget(self, action: #selector(self.unFollowBtnPressed), for: .touchUpInside)
                DatabaseManager.shared.fireStore.collection("Users").document(userid).getDocument { query, error in
                    guard error == nil else{
                        let popup = UIAlertController(title: "حدث خطأ", message: "حدث خطأ إثناء الاتصال بالسيرفر، حاول مرة أخرى من فضلك", preferredStyle: .alert)
                        let action = UIAlertAction(title: "تم", style: .default)
                        popup.addAction(action)
                        self.present(popup, animated: true, completion: nil)
                        return
                    }
                    if let followingUsers = query?.get("followingUsers"){
                        self.userDefault.set(followingUsers, forKey: "\(DatabaseManager.shared.authRef.currentUser!.uid)followingUsers")
                        
                    }
                }
            }
            
        }
    }
    
    @objc func unFollowBtnPressed(){
        if let userid = DatabaseManager.shared.authRef.currentUser?.uid{
            DatabaseManager.shared.fireStore.collection("Users").document(userid).updateData(["followingUsers" : FieldValue.arrayRemove([shownUserID!])]) { error in
                guard error == nil else{
                    let popup = UIAlertController(title: "حدث خطأ", message: "حدث خطأ إثناء الاتصال بالسيرفر، حاول مرة أخرى من فضلك", preferredStyle: .alert)
                    let action = UIAlertAction(title: "تم", style: .default)
                    popup.addAction(action)
                    self.present(popup, animated: true, completion: nil)
                    return
                }
                self.followBtn.backgroundColor = .green
                self.followBtn.setTitle("follow", for: .normal)
                self.followBtn.addTarget(self, action: #selector(self.followBtnPressed), for: .touchUpInside)
                DatabaseManager.shared.fireStore.collection("Users").document(userid).getDocument { query, error in
                    guard error == nil else{
                        let popup = UIAlertController(title: "حدث خطأ", message: "حدث خطأ إثناء الاتصال بالسيرفر، حاول مرة أخرى من فضلك", preferredStyle: .alert)
                        let action = UIAlertAction(title: "تم", style: .default)
                        popup.addAction(action)
                        self.present(popup, animated: true, completion: nil)
                        return
                    }
                    if let followingUsers = query?.get("followingUsers"){
                        self.userDefault.set(followingUsers, forKey: "\(DatabaseManager.shared.authRef.currentUser!.uid)followingUsers")
                    }
                }
            }
            
        }
    }
    
    func fetchFollowingUsers(completion: @escaping ([String]?) -> Void){
        DatabaseManager.shared.fireStore.collection("Users").document(DatabaseManager.shared.authRef.currentUser!.uid).getDocument{ result, error in
            guard error == nil else{
                print(error!.localizedDescription)
                completion(nil)
                return
            }
            
            if let followingUsers = result?.get("followingUsers") as! [String]? {
                self.followingUsers = followingUsers
                completion(followingUsers)
                self.userDefault.set(followingUsers, forKey: "\(DatabaseManager.shared.authRef.currentUser!.uid)followingUsers")
                
            }
            else{
                print("No data because you did not follow any user yer")
                completion(nil)
            }
        }
    }
    
    func fetchUserData(id: String){
        DatabaseManager.shared.fireStore.collection("Users").document(id).addSnapshotListener{
            query, error in
            guard error == nil else{
                let popup = UIAlertController(title:"خطأ", message: "حدث خطأ في جلب البيانات، تأكد من اتصالك بالانترنت ثم حاول مرة أخرى", preferredStyle: .alert)
                let action = UIAlertAction(title: "تم", style: .default)
                popup.addAction(action)
                self.present(popup, animated: true, completion: nil)
                return
            }
            if let userName = query?.get("userName") as? String {
                self.labelUsername.text = userName
            }
            if let followingUsers = query?.get("followingUsers") as? [String] {
                self.followingUsersNum.text = "\(followingUsers.count)"
            }
            else{
                self.followingUsersNum.text = "0"
                
            }
            DispatchQueue.global().async {
                self.getUserPicture(id: id){ data in
                    if data != nil {
                        self.profileImage.image = UIImage(data: data!)
                    }else{
                        self.profileImage.image = UIImage(systemName: "person.circle")
                        
                    }
                }
                DispatchQueue.global().async {
                    DatabaseManager.shared.fireStore.collection("Sessions").whereField("userID", isEqualTo: id).addSnapshotListener{
                        result, error in
                        guard error == nil else{
                            let popup = UIAlertController(title:"خطأ", message: "حدث خطأ في جلب البيانات، تأكد من اتصالك بالانترنت ثم حاول مرة أخرى", preferredStyle: .alert)
                            let action = UIAlertAction(title: "تم", style: .default)
                            popup.addAction(action)
                            self.present(popup, animated: true, completion: nil)
                            return
                        }
                        self.sesstions.removeAll()
                        if let docs = result?.documents{
                            self.numberOfSesstions.text = "\(docs.count)"
                            for doc in docs{
                                if let timeInterval = doc.get("timeInterval") as? Double{
                                    let userSession = userSession(sessionID:  doc.get("sesstionID") as! String, category: doc.get("category") as! String, title: doc.get("title") as! String, dataCreated: doc.get("date") as! String, isClosed: doc.get("isClosed") as! Bool, timeInterval: timeInterval)
                                    self.sesstions.append(userSession)
                                }}
                        }else{
                            self.numberOfSesstions.text = "0"
                            
                        }
                        
                        
                        
                        
                        self.sesstions = self.sesstions.sorted{
                            $0.timeInterval >= $1.timeInterval
                        }
                        self.tableView.reloadData()
                    }
                    
                }
                
            }
        }
    }
    func getUserPicture(id: String, completion: @escaping(Data?)->Void){
        
        DatabaseManager.shared.storageRef.reference().child("\(id).jpeg").downloadURL { url, error in
            guard error == nil else{
                print(error!.localizedDescription)
                completion(nil)
                return
            }
            let data = try! Data(contentsOf: url!)
            completion(data)
        }
    }
    
    @objc func endSesstion(){
        deleteSesstion{ deleted in
            if deleted{
                self.tableView.reloadData()
            }
        }
    }
    func deleteSesstion(completion:@escaping (Bool) -> Void){
        if sesstions.first != nil{
            if sesstions.first!.isClosed == false{
                DatabaseManager.shared.fireStore.collection("Sessions").document(sesstions.first!.sessionID).updateData(["isClosed" : true]){
                    error in
                    guard error == nil else{
                        let popup = UIAlertController(title: "مشكلة", message: "حدث خطأ اثناء اغلاق الجلسة، حاول مرة أخرى", preferredStyle: .alert)
                        let action = UIAlertAction(title: "تم", style: .default)
                        popup.addAction(action)
                        self.present(popup, animated: true, completion: nil)
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
        }
    }
    @IBAction func logOut(_ sender: Any) {
        do {
            try DatabaseManager.shared.authRef.signOut()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "login")
            let nav = UINavigationController(rootViewController: vc!)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
            print("Signed out successfully")
        }catch let signOutError as NSError{
            print("Error signing out: %@", signOutError)
        }
    }
    
    
    
    
}

extension ProfileViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! profileTableViewCell
        
        cell.layer.cornerRadius = 16
        cell.categoryLabel.text = sesstions[indexPath.section].category
        cell.titleLabel.text = sesstions[indexPath.section].title
        cell.dateLabel.text = sesstions[indexPath.section].dataCreated
        if sesstions[indexPath.section].isClosed == false{
            cell.isClosed.textColor = .init(UIColor(red: 0, green: 0.5098, blue: 0.1608, alpha: 1.0))
            cell.isClosed.text = "مفتوحة"
            if shownUserID == nil{
                cell.endSessionBtn.isEnabled = true
                cell.endSessionBtn.isHidden = false
                cell.endSessionBtn.addTarget(self, action: #selector(endSesstion), for: .touchUpInside)
            }
        }else{
            cell.isClosed.textColor = .red
            cell.isClosed.text = "مغلقة"
            if shownUserID == nil{
                cell.endSessionBtn.isEnabled = false
                cell.endSessionBtn.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sesstions.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = view.backgroundColor
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


