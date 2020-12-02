//
//  ParameterSlider.swift
//  petTinderApp
//
//  Created by Alok Acharya on 11/11/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

class ParameterSlider: UIView {
    
    let sliderItems : [String]
    let titleLbl : String
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = Float(sliderItems.count - 1)
        slider.addTarget(self, action: #selector(handleSlider), for: .valueChanged)
        return slider
    }()
    
    let titleLabel : UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.boldSystemFont(ofSize: 18)
        title.textAlignment = .left
        return title
    }()
    
    let itemLabel : UILabel = {
        let item = UILabel()
        item.textColor = .black
        item.font = UIFont.boldSystemFont(ofSize: 15)
        item.textAlignment = .center
        return item
    }()
    
    init(items: [String], titleLbl: String) {
        self.sliderItems = items
        self.titleLbl = titleLbl
        super.init(frame: .zero)
        
        backgroundColor = .cyan
        layer.cornerRadius = 20
        sizeToFit()
        
        titleLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        titleLabel.text = self.titleLbl
        
        itemLabel.text = sliderItems.first
        
        let sliderStackView = UIStackView(arrangedSubviews: [slider, itemLabel])
        sliderStackView.distribution = .fillEqually
        sliderStackView.spacing = 5
        sliderStackView.axis = .vertical
        
        let overallStackView = UIStackView(arrangedSubviews: [titleLabel, sliderStackView])
        overallStackView.axis = .horizontal
        overallStackView.spacing = 10
        overallStackView.distribution = .fillProportionally
        
        
        addSubview(overallStackView)
        overallStackView.fillSuperview(padding: .init(top: 5, left: 10, bottom: 5, right: 10))
    }
    
    @objc fileprivate func handleSlider(slider: UISlider){
        let step: Float = 1
        
        let roundedStepValue = round(slider.value / step) * step
        slider.value = roundedStepValue
        
        let index = Int(roundedStepValue)
        
        itemLabel.text = sliderItems[index]
    }
    
    func resetSliders(){
        UIView.animate(withDuration: 0.7) {
            self.slider.setValue(0, animated: true)
            self.itemLabel.text = self.sliderItems.first
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
