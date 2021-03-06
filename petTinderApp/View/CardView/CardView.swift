//
//  CardView.swift
//  petTinderApp
//
//  Created by Alok Acharya on 8/31/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didPressMoreInfo(url: String)
}

class CardView: UIView{
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let moreInfoBtn: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(#imageLiteral(resourceName: "paw").withRenderingMode(.alwaysTemplate), for: .normal)
        b.tintColor = .red
        return b
    }()
    
    var nextCard: CardView?
    var delegate: CardViewDelegate?
    var profileVCDelegate : ProfileViewControllerProtocol?
    
    var cardViewModel: AnimalCardViewModel!{
        didSet{
            swipingPhotoController.cardViewModel = self.cardViewModel
            infoLabel.attributedText = cardViewModel.cardAttributedString
            infoLabel.textAlignment = cardViewModel.textAlignment
        }
    }
    
    var paginationUrl: String!
    
    fileprivate let swipingPhotoController = SwipingPhotosController(isCardViewMode: true)
    fileprivate let infoLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCardLayout()
        setupCardPanGesture()
        
    }
    
    fileprivate let threshold: CGFloat = 80
    let gradientLayer = CAGradientLayer()
    
    fileprivate func setupGradient() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.4]
        layer.addSublayer(gradientLayer)
    }
    
    fileprivate func setupCardLayout() {
        clipsToBounds = true
        layer.cornerRadius = 15
        
        let swipingPhotosView = swipingPhotoController.view!
        addSubview(swipingPhotosView)
        swipingPhotosView.fillSuperview()
        
        
        setupGradient()
        
        addSubview(infoLabel)
        infoLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        
        infoLabel.textColor = .white
        infoLabel.numberOfLines = 0
        
        addSubview(moreInfoBtn)
        moreInfoBtn.anchor(top: nil, leading: nil, bottom: bottomAnchor , trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 15, right: 15), size: .init(width: 44, height: 44))
        moreInfoBtn.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        
    }
    
    @objc fileprivate func handleMoreInfo(){
        let petfinderUrl = cardViewModel.petFinderUrl
        delegate?.didPressMoreInfo(url: petfinderUrl)
    }

    override func layoutSubviews() {
        gradientLayer.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - Card Movement - Pan Gesture
extension CardView{
    
    fileprivate func setupCardPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        addGestureRecognizer(panGesture)
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
            profileVCDelegate?.settingsDidGoUp()
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture: gesture)
            profileVCDelegate?.settingsDidGoDown()
        default:
            ()
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        // rotation
        // some not that scary math here to convert radians to degrees
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
        
        let percentage = abs(translation.x / (superview?.frame.maxX)!) / 80 + 1
        
        if let nextCard = nextCard{
            nextCard.isHidden = false
            nextCard.alpha = abs(translation.x / (superview?.frame.maxX)!) + 0.5
            let scaleTransformation = CGAffineTransform(scaleX: percentage, y: percentage)
            nextCard.transform = scaleTransformation
        }
        
        
    }
    
    fileprivate func handleEnded(gesture: UIPanGestureRecognizer) {
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        
        if shouldDismissCard{
            //hack solution
            guard let homeController = self.delegate as? ProfileViewController else { return }
            
            if translationDirection == 1 {
                homeController.handleLike()
            }else{
                homeController.handleDislike()
            }
        }else{
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                self.transform = .identity
            })
        }
    }
    
}

