//
//  onBoardingViewController.swift
//  FinalProject
//
//  Created by Faisal Almutairi on 23/02/1444 AH.
//

import UIKit

class onBoardingViewController: UIViewController {

    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    var slides : [OnboardingSlide] = []
//    let isRTL = Locale.characterDirection(forLanguage: "rtl") == .rightToLeft

   
    var countPages = 0 {
        didSet{
            pageControl.currentPage = countPages
            if countPages == slides.count - 1{
                nextBtn.setTitle("إبدأ الأن", for: .normal)
            } else {
                nextBtn.setTitle("التالي", for: .normal)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()


        nextBtn.layer.cornerRadius = 16
        collectionView.delegate = self
        collectionView.dataSource = self
        nextBtn.setTitle("التالي", for: .normal)
//        pageControl.transform = CGAffineTransform(scaleX: -1, y: 1);
        
        slides = [
            OnboardingSlide(title: "أهلاً بك في تطبيق هاوي", descripion: "إجتمع مع أشخاص في نفس اهتمامك", image: UIImage(named: "pngwing.com")!) ,OnboardingSlide(title: "first page", descripion: "first page", image: UIImage(named: "pngwing.com")!),OnboardingSlide(title: "first page", descripion: "first page", image: UIImage(named: "pngwing.com")!)
                 ]

//        UIView.appearance().semanticContentAttribute = isRTL
//            ? .forceRightToLeft
//            : .forceLeftToRight
    }

    @IBAction func nextActionBtn(_ sender: UIButton) {
        
        if countPages == slides.count - 1 {
            let controller = storyboard?.instantiateViewController(withIdentifier: "login")
            controller?.modalPresentationStyle = .fullScreen
            controller?.modalTransitionStyle = .coverVertical
            present(controller!, animated: true, completion: nil)
        }else {
            countPages += 1
            let indexPath = IndexPath(item: countPages, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}



extension onBoardingViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onBoardingCell", for: indexPath) as! onBoardingCollectionViewCell
        
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let width = scrollView.frame.width
        countPages = Int(scrollView.contentOffset.x / width)
    }
    
    
    
}
