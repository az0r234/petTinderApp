//
//  RegisterViewController.swift
//  petTinderApp
//
//  Created by Alok Acharya on 11/28/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

class RegisterViewController: UICollectionViewController {
//class RegisterViewController: UIViewController{
    
    var percentage: Float = 0
    var page = 0
    
    let progressView : UIProgressView = {
        let pV = UIProgressView(progressViewStyle: .bar)
        pV.trackTintColor = .lightGray
        pV.progressTintColor = .red
        pV.withHeight(30)
        return pV
    }()
    
    let button : UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .green
        return btn
    }()
    
    let backBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .red
        return btn
    }()
    
    let firstView = UIView()
    let secondView = UIView()
    let thirdView = UIView()
    var collectionViewArray = [UIView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        firstView.backgroundColor = .blue
        secondView.backgroundColor = .green
        thirdView.backgroundColor = .brown
    
        collectionViewArray = [firstView, secondView, thirdView, firstView, secondView]
        
        collectionView.delegate = self
        registerAndSetupCollection()
        view.addSubview(button)
        button.frame = CGRect(x: 0, y: 0, width: 220, height: 55)
        button.center = view.center
        button.addTarget(self, action: #selector(handleGoForward), for: .touchUpInside)

        view.addSubview(backBtn)
        backBtn.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, size: .init(width: 220, height: 55))
        backBtn.addTarget(self, action: #selector(handleGoBack), for: .touchUpInside)

        view.addSubview(progressView)
        progressView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        progressView.setProgress(percentage, animated: false)
        
    }
    
    fileprivate func registerAndSetupCollection(){
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.layer.cornerRadius = 25
    }
    
    @objc private func handleGoForward(){
        let increment = 1/Float(collectionViewArray.count-1)
        page = page + 1
        percentage = percentage + increment
        percentage = !(percentage < 1.0) ? 1.0 : percentage
        progressView.setProgress(percentage, animated: true)
        
        page = (page > collectionViewArray.count - 1) ? collectionViewArray.count - 1 : page
        let indexPath = IndexPath(item: page, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
    }
    
    @objc fileprivate func handleGoBack(){
        let decrement = 1/Float(collectionViewArray.count-1)
        page = page - 1
        percentage = percentage - decrement
        percentage = (percentage < 0) ? 0 : percentage
        progressView.setProgress(percentage, animated: true)
        page = (page < 0) ? 0 : page
        let indexPath = IndexPath(item: page, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        
    }
    
}

extension RegisterViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        let arrayItem = collectionViewArray[indexPath.item]
        cell.addSubview(arrayItem)
        arrayItem.fillSuperview()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    
}
