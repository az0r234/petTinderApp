//
//  AnimalPreferenceSettingView.swift
//  petTinderApp
//
//  Created by Alok Acharya on 11/7/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

class BottomStackView: UIStackView {
    let submitBtn = CustomButton(centerLabel: .Submit, background: .cyan)
    let resetBtn = CustomButton(centerLabel: .Reset, background: .cyan)
    let exitBtn = CustomButton(centerLabel: .Exit, background: .cyan)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
        distribution = .fillEqually
        spacing = 10
        
        resetBtn.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        exitBtn.layer.cornerRadius = 0
        submitBtn.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
        [resetBtn, exitBtn, submitBtn].forEach { (btn) in
            addArrangedSubview(btn)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AnimalPreferences: UIView {
    let typeBtn = ParametersButtons(leftLabel: .AnimalType)
    let breedBtn = ParametersButtons(leftLabel: .Breed)
    let colorBtn = ParametersButtons(leftLabel: .Color)
    let coatBtn = ParametersButtons(leftLabel: .Coat)
    
    let sizeSlider = ParameterSlider(items: K.sizeArray, titleLbl: .Size)
    let genderSlider = ParameterSlider(items: K.genderArray, titleLbl: .Gender)
    let ageSlider = ParameterSlider(items: K.ageArray, titleLbl: .Age)
    let rangeSlider = ParameterSlider(items: K.rangeArray, titleLbl: .Range)
    
    let bottomStack = BottomStackView()
    
    fileprivate lazy var buttonStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [typeBtn, breedBtn, colorBtn, coatBtn, sizeSlider, genderSlider, ageSlider, rangeSlider, bottomStack])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let random = ButtonTitles.Random.rawValue
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(buttonStack)
        buttonStack.fillSuperview(padding: .init(top: 20, left: 15, bottom: 30, right: 15))
        
        makeButtonVisible()
        
    }
    
    func resetButtons(){
        [typeBtn, breedBtn, colorBtn, coatBtn].forEach { (button) in
            button.rightLbl.text = random
        }
        
        [sizeSlider, genderSlider, ageSlider].forEach { (slider) in
            slider.resetSliders()
        }
        
        self.alpha = 0
        makeButtonVisible()
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            self.alpha = 1
        } completion: { (_) in
        }
    }
    
    func makeButtonVisible(){
        if typeBtn.rightLbl.text != random{
            [breedBtn, colorBtn, coatBtn].forEach { (button) in
                button.isHidden = false
            }
        }else{
            [breedBtn, colorBtn, coatBtn].forEach { (button) in
                button.isHidden = true
                button.rightLbl.text = random
            }
        }
    }
    
    func resetButtonsWhenTypeChanges(){
        [breedBtn, colorBtn, coatBtn].forEach { (button) in
            button.rightLbl.text = random
        }
        
        [sizeSlider, genderSlider, ageSlider].forEach { (slider) in
            slider.resetSliders()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
