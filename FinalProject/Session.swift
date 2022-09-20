//
//  Session.swift
//  FinalProject
//
//  Created by Maan Abdullah on 13/09/2022.
//

import Foundation
import UIKit
import CoreLocation

struct Session{
    let userPicture: Data?
    var userName: String
    let title: String
    let description: String?
    let category: String?
    let userID: String
    let sesstionLocation: Double
//    let cateImage: String
    let lat: Double?
    let long: Double?
}


enum Category: String{
    case Computer = "الحاسب الآلي"
    case Programming = "برمجة"
    case Technology = "تقنية"
    case Sport = "رياضة"
    case Engineering = "هندسة"
    case Isalmic = "إسلام"
    case Football = "كرة القدم"
    case Education = "تعليم"
}
