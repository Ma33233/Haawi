//
//  shortViewController.swift
//  FinalProject
//
//  Created by Faisal Almutairi on 19/02/1444 AH.
//

import UIKit

class shortViewController: UIViewController {

    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionView.layer.cornerRadius = 16
//        infoView.layer.cornerRadius = 16
    }
    

}
