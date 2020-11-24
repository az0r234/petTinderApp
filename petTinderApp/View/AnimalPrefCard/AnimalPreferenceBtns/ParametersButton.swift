//
//  ParametersButton.swift
//  petTinderApp
//
//  Created by Alok Acharya on 11/10/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

class ParametersButtons: UIButton {
    private var leftLabel: String
    private var rightLabel: String
    let leftLbl = UILabel()
    let rightLbl = UILabel()
    
    init(leftLabel: String, rightLabel: String) {
        
        self.leftLabel = leftLabel
        self.rightLabel = rightLabel
        super.init(frame: .zero)
        
        setupButtonAttr()
        setLabels()
        addSubview(leftLbl)
        addSubview(rightLbl)
        addLabelsToSubview()
        
    }
    
    fileprivate func setupButtonAttr(){
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 70).isActive = true
        backgroundColor = .cyan
        layer.cornerRadius = 20
        sizeToFit()
    }
    
    fileprivate func setLabels(){
        leftLbl.translatesAutoresizingMaskIntoConstraints = false
        leftLbl.text = leftLabel
        leftLbl.font = UIFont.boldSystemFont(ofSize: 18)
        leftLbl.textAlignment = .left
        
        rightLbl.translatesAutoresizingMaskIntoConstraints = false
        rightLbl.textColor = .gray
        rightLbl.text = rightLabel
        rightLbl.font = UIFont.boldSystemFont(ofSize: 18)
        rightLbl.textAlignment = .right
    }
    
    fileprivate func addLabelsToSubview() {
        if K.specialBtnTitleArray.contains(self.leftLabel){
            leftLbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            leftLbl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            leftLbl.textAlignment = .center
        }else{
            leftLbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            leftLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        }
        
        if !self.rightLabel.isEmpty{
            rightLbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            rightLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
