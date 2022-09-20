//
//  onBoardingCollectionViewCell.swift
//  FinalProject
//
//  Created by Faisal Almutairi on 23/02/1444 AH.
//

import UIKit

class onBoardingCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func setup(_ slide:OnboardingSlide){
        imageView.image = slide.image
        titleLabel.text = slide.title
        descriptionLabel.text = slide.descripion
    }
}
