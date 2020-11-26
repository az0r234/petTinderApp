//
//  AnimalPreferenceSettingView.swift
//  petTinderApp
//
//  Created by Alok Acharya on 11/7/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

class BottomStackView: UIStackView {
    let submitBtn = CustomButton(centerLabel: K.submitBtn)
    let resetBtn = CustomButton(centerLabel: K.resetBtn)
    let exitBtn = CustomButton(centerLabel: K.exitBtn)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
        distribution = .fillEqually
        spacing = 10
    
        submitBtn.backgroundColor = .cyan
        resetBtn.backgroundColor = .cyan
        exitBtn.backgroundColor = .cyan
        
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
    let typeBtn = ParametersButtons(leftLabel: K.typeBtn, rightLabel: K.random)
    let breedBtn = ParametersButtons(leftLabel: K.breedBtn, rightLabel: K.random)
    let colorBtn = ParametersButtons(leftLabel: K.colorBtn, rightLabel: K.random)
    let coatBtn = ParametersButtons(leftLabel: K.coatBtn, rightLabel: K.random)
    
    let sizeBtn = ParameterSlider(items: K.sizeArray, titleLbl: K.sizeBtn)
    let genderBtn = ParameterSlider(items: K.genderArray, titleLbl: K.genderBtn)
    let ageBtn = ParameterSlider(items: K.ageArray, titleLbl: K.ageBtn)
    let locationRange = ParameterSlider(items: K.rangeArray, titleLbl: K.rangeBtn)
    
    let bottomStack = BottomStackView()
    
    fileprivate lazy var buttonStack: UIStackView = {
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [typeBtn, breedBtn, colorBtn, coatBtn, sizeBtn, genderBtn, ageBtn, locationRange, bottomStack])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(buttonStack)
        buttonStack.fillSuperview(padding: .init(top: 20, left: 15, bottom: 30, right: 15))
        
        breedBtn.isHidden = true
        colorBtn.isHidden = true
        coatBtn.isHidden = true
    }
    
    func resetButtons(){
        typeBtn.rightLbl.text = K.random
        breedBtn.rightLbl.text = K.random
        colorBtn.rightLbl.text = K.random
        coatBtn.rightLbl.text = K.random
        
        sizeBtn.resetSliders()
        genderBtn.resetSliders()
        ageBtn.resetSliders()
        
        self.alpha = 0
        makeButtonVisible()
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            self.alpha = 1
        } completion: { (_) in
        }
    }
    
    func makeButtonVisible(){
        if typeBtn.rightLbl.text != K.random{
            breedBtn.isHidden = false
            colorBtn.isHidden = false
            coatBtn.isHidden = false
        }else{
            breedBtn.isHidden = true
            colorBtn.isHidden = true
            coatBtn.isHidden = true
            breedBtn.rightLbl.text = K.random
            colorBtn.rightLbl.text = K.random
            coatBtn.rightLbl.text = K.random
        }
    }
    
    func resetButtonsWhenTypeChanges(){
        breedBtn.rightLbl.text = K.random
        colorBtn.rightLbl.text = K.random
        coatBtn.rightLbl.text = K.random
        
        sizeBtn.resetSliders()
        genderBtn.resetSliders()
        ageBtn.resetSliders()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
