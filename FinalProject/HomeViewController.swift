//
//  HomeViewController.swift
//  FinalProject
//
//  Created by AlenaziHazal on 16/02/1444 AH.
//

import UIKit
import CoreLocation
import ProgressHUD
class HomeViewController: UIViewController {
    @IBOutlet weak var collectionViewHome: UICollectionView!
    @IBOutlet weak var addSetionBtn: UIButton!
    @IBOutlet weak var labelAppName: UILabel!
    var textLabel: UILabel! = UILabel(frame: CGRect(x: 115, y: 490 , width: 200, height: 40))
    var imgError: UIImageView! = UIImageView(frame: CGRect(x: 135, y: 330, width: 150, height: 150))
    //MARK: - Variables:
    let userDefault = UserDefaults.standard
    var sesstionsArr = [Session]()
    var filteredArr = [Session]()
    var dic = [User: [Session]]()
    var userID: String?
    var followingUsers: [String]? = nil
    var userLocation: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewHome.dataSource = self
        collectionViewHome.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        userLocation = locationManager.location?.coordinate
        collectionViewHome.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "sessionCell")
        ProgressHUD.show()
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorAnimation = .systemBlue
        isLoggedIn(){ login in
            if login{
                self.userID = DatabaseManager.shared.authRef.currentUser!.uid
                self.fetchUserFollowingData(){ isFollowOne in
                    if isFollowOne{
                        self.fetchSessionsData(){ _ in
                            if self.sesstionsArr.count == 0 {
                                self.collectionViewHome.isHidden = true
                                self.imgError.image = UIImage(systemName: "house")
                                self.imgError.tintColor = .lightGray

                                self.view.addSubview(self.imgError)

                                self.textLabel.text = "لا يوجد جلسة متاحة الأن"
                                self.textLabel.textAlignment = .center
                                self.textLabel.textColor = .lightGray
                                self.view.addSubview(self.textLabel)
                                ProgressHUD.dismiss()

                                
                            }
                            else{
                                self.collectionViewHome.isHidden = false
                                self.imgError.isHidden = true
                                self.textLabel.isHidden = true
                            }
                        }

                    }
                    else{
                        self.collectionViewHome.isHidden = true
                        self.imgError = UIImageView(frame: CGRect(x: 135, y: 330, width: 150, height: 150))
                        self.imgError.image = UIImage(systemName: "house")
                        self.imgError.tintColor = .lightGray

                        self.view.addSubview(self.imgError)

                        self.textLabel = UILabel(frame: CGRect(x: 115, y: 690 , width: 200, height: 40))

                        self.textLabel.text = "لا يوجد جلسة متاحة الأن"
                        self.textLabel.textAlignment = .center
                        self.textLabel.textColor = .lightGray
                        self.view.addSubview(self.textLabel)
                        ProgressHUD.dismiss()

                    }
                }
            }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ProgressHUD.dismiss()
    }
    
    //MARK: - IBActions
    @IBAction func addSectionButten(_ sender: Any) {
        performSegue(withIdentifier: "addSection", sender: nil)
    }
    @IBAction func backHome(segue: UIStoryboardSegue) {
        
    }
    
    //MARK: - Methods:
    
    // method to perform automatic login for user
    func isLoggedIn(comletion: @escaping (Bool) -> Void){
        if DatabaseManager.shared.authRef.currentUser == nil {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "login")
            let nav = UINavigationController(rootViewController: vc!)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
            comletion(false)
        }
        if userDefault.object(forKey: "email") != nil && userDefault.object(forKey: "password") != nil {
            DatabaseManager.shared.authRef.signIn(withEmail: userDefault.object(forKey: "email") as! String, password: userDefault.object(forKey: "password") as! String){ result, error in
                guard error == nil else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "login")
                    let nav = UINavigationController(rootViewController: vc!)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true)
                    comletion(false)
                    return
                }
                comletion(true)
            }
        }
        else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "login")
            vc!.modalPresentationStyle = .fullScreen
            vc!.modalTransitionStyle = .coverVertical
            self.present(vc!, animated: true)
        }
    }
    
    func fetchUserFollowingData(completion: @escaping(Bool) -> Void){
        DatabaseManager.shared.fireStore.collection("Users").document(userID!).addSnapshotListener { result, error in
            guard error == nil else{
                print(error!.localizedDescription)
                completion(false)
                return
            }
                
            if let followingUsers = result?.get("followingUsers"){
                if let followedUsers = followingUsers as? [String] {
                    if !followedUsers.isEmpty{
                self.followingUsers = followedUsers
                self.userDefault.set(followingUsers, forKey: "\(DatabaseManager.shared.authRef.currentUser!.uid)followingUsers")
                    completion(true)
                    }
                    else{
                    completion(false)

                    }
            }
            }
            else{
                print("No data because you did not follow any user yer")
                ProgressHUD.dismiss()
                completion(false)
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
    
    func fetchSessionsData(completion: @escaping(Bool) -> Void){
        DatabaseManager.shared.fireStore.collection("Sessions").whereField("userID", in: followingUsers!).whereField("isClosed", isEqualTo: false).addSnapshotListener{ query, error in
            guard error == nil else{
                print("error fetching data")
                completion(false)
                return
            }
            self.sesstionsArr.removeAll()
            self.dic.removeAll()
            for doc in query!.documents{
                let userid = doc.get("userID")
                
                DatabaseManager.shared.fireStore.collection("Users").document(userid as! String).addSnapshotListener{ result, error in
                    guard error == nil else{
                        print(error!.localizedDescription)
                        completion(false)
                        return
                    }
                    
                    self.getUserPicture(id: userid as! String){ data in
                        self.locationManager.startUpdatingLocation()
                        if let userLocation = self.userLocation {
                            if let sesstionLat = doc.get("lat") as? Double{
                                if let sesstionLong =  doc.get("long") as? Double{
                                    let sesstionDistance = self.calcDistance(userLocation: userLocation, sesstionLocation: CLLocationCoordinate2D(latitude: sesstionLat, longitude: sesstionLong))
                                    if sesstionDistance < 10{
                                        let sesstion = Session(userPicture: data, userName: result?.get("userName") as! String, title: doc.get("title")as! String, description: result?.get("description") as! String?, category: doc.get("category") as! String?, userID: doc.get("userID") as! String, sesstionLocation: sesstionDistance, lat: sesstionLat, long: sesstionLong)
                                    //                            self.sesstionsArr.append(sesstion)
                                    let user = User(userID: userid as! String, userName: result?.get("userName") as! String, fullName: nil, bio: nil, followingUsers: nil, profilePicture: nil)
                                    
                                    let users = self.dic.keys
                                    
                                    if users.contains(where: { u in
                                        u.userID == user.userID
                                    }){
                                        let changedUser = users.first { u in
                                            u.userID == user.userID
                                        }
                                        let session = self.dic[changedUser!]
                                        self.dic.removeValue(forKey: changedUser!)
                                        self.dic[user] = session
                                        for s in self.sesstionsArr {
                                            if s.userID == changedUser!.userID{
                                                var removedSession = self.sesstionsArr.first { ss in
                                                    ss.userName == changedUser!.userName
                                                }
                                                let seesionIndex = self.sesstionsArr.firstIndex { session in
                                                    session.userID == changedUser!.userID &&                                         session.userName == changedUser!.userName

                                                }
                                                self.sesstionsArr.remove(at: seesionIndex!)
                                                removedSession?.userName = user.userName
                                                self.sesstionsArr.append(removedSession!)

                                            }
                                        }
                                    }else{
                                        self.dic[user] = []
                                        self.dic[user]!.append(sesstion)
                                        self.sesstionsArr.append(sesstion)
                                       
                                    }
                                }
                            }
                        }
                        }
                        self.filteredArr = self.sesstionsArr.sorted{
                            $0.sesstionLocation <= $1.sesstionLocation
                        }
                        self.collectionViewHome.reloadData()
                        completion(true)

                    }
                }
                
            }
        }
        
    }
    
    func calcDistance(userLocation: CLLocationCoordinate2D, sesstionLocation: CLLocationCoordinate2D) -> Double{
        let userCoordinate = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let sesstionCoordinate = CLLocation(latitude: sesstionLocation.latitude, longitude: sesstionLocation.longitude)
        return Double(round((userCoordinate.distance(from: sesstionCoordinate) / 1000) * 1000) / 1000)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showInfo" else{
            print("error in segue")
            return
        }
        guard let distination = segue.destination as? CollectionInfoViewController else { print("error in dis")
            return}
        guard let index = sender as? IndexPath else{return}
        distination.sesstion = filteredArr[index.item]
    }
    
}

extension HomeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        ProgressHUD.dismiss()
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "sessionCell", for: indexPath) as! CustomCollectionViewCell
        item.personNameLabel.text = filteredArr[indexPath.item].userName
        if filteredArr[indexPath.item].userPicture == nil{
        item.personImage.image = UIImage(systemName: "person.circle")
        }
        else{
            item.personImage.image = UIImage(data: filteredArr[indexPath.item].userPicture!)
        }
        item.titleLabel.text = filteredArr[indexPath.item].title
        item.categoryLabel.text = filteredArr[indexPath.item].category
        item.distanceLabel.text = "\(filteredArr[indexPath.item].sesstionLocation) KM"
        item.layer.cornerRadius = 16
        return item
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showInfo", sender: indexPath)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let columns: CGFloat = 2
        let collectionViewWidth = collectionView.bounds.width
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let spaceBetweenCells = flowLayout.minimumInteritemSpacing * (columns - 1)
        let sectionInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right
        let adjustedWidth = collectionViewWidth - spaceBetweenCells - sectionInsets
        let width: CGFloat = floor(adjustedWidth / columns)
        let height: CGFloat = width / 0.8
        return CGSize(width: width, height: height)
    }
}
