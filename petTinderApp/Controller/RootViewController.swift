//
//  testCollectionViewController.swift
//  petTinderApp
//
//  Created by Alok Acharya on 12/4/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

private let reuseIdentifier = "rootCellId"
class RootViewController: UICollectionViewController {
    
    let settingsVC = SettingsViewController()
    let profileVC = ProfileViewController()
    let pickedAnimalVC = PickedAnimalsViewController()
    let darkView = UIView()
    var collectionViewArray = [UIViewController]()
    
    lazy var topBar : TopBar = {
        let tBar = TopBar()
        tBar.rootController = self
        return tBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionViewArray = [settingsVC, profileVC, pickedAnimalVC]
        
        
        setupTopBar()
        setupCollectionView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupDarkView()
    }
    
    fileprivate func setupTopBar(){
        view.addSubview(topBar)
        topBar.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 100))
    }
    
    fileprivate func setupCollectionView(){
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.scrollDirection = .horizontal
        }
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.anchor(top: topBar.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        collectionView.delegate = self
        
    }
    
    func setupDarkView(){
        darkView.backgroundColor = .black
        darkView.alpha = 1
        view.addSubview(darkView)
        darkView.fillSuperview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let indexPath = IndexPath(row: 1, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        
        UIView.animate(withDuration: 0.5) {
            self.darkView.alpha = 0
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout Methods

extension RootViewController: UICollectionViewDelegateFlowLayout{
    
    func scrollToMenuItem(menuItem: Int){
        let indexPath = IndexPath(item: menuItem, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        topBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        collectionViewArray[indexPath.row].viewWillAppear(true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionViewArray[indexPath.row].viewDidDisappear(true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let viewOutuput = collectionViewArray[indexPath.row]
        addChild(viewOutuput)
        cell.addSubview(viewOutuput.view)
        viewOutuput.view.fillSuperview()
        viewOutuput.didMove(toParent: self)
        viewOutuput.viewDidLoad()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.height - topBar.frame.height
        return CGSize(width: view.frame.width, height: height)
    }
}
