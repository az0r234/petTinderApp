//
//  testCollectionViewController.swift
//  petTinderApp
//
//  Created by Alok Acharya on 12/4/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

private let reuseIdentifier = "RootCellId"

class testCollectionViewController: UICollectionViewController {
    
    let settingsVC = SettingsViewController()
    let profileVC = ProfileViewController()
    let pickedAnimalVC = PickedAnimalsViewController()
    lazy var collectionViewArray: [UIViewController] = [settingsVC, profileVC, pickedAnimalVC]
    let topBar = TopSlidingBar()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(topBar)
        topBar.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: view.frame.width, height: 100))
        
        collectionView.anchor(top: topBar.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        view.bringSubviewToFront(topBar)
        topBar.profileButton.isEnabled = true
        topBar.changeTintForButtons()
        collectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath(row: 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
       
    }
    
    
}

extension testCollectionViewController: UICollectionViewDelegateFlowLayout{
    

    
    fileprivate func getCurrentIndex()->Int{
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint)
        let row = visibleIndexPath!.row
        return row
    }
    

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let currentIndex = getCurrentIndex()
//        collectionViewArray[currentIndex].viewWillDisappear(true)
//        print(currentIndex)
    }
    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
//        if let ip = collectionView.indexPathForItem(at: center) {
//            print(ip.row)
//        }
//    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
//        switch indexPath.row {
//        case 0:
//            topBar.settingsButton.isEnabled = false
//            break
//        case 1:
//            topBar.profileButton.isEnabled = false
//            break
//        case 2:
//            topBar.pickedAnimalsButton.isEnabled = false
//            break
//        default:
//            break
//        }
//        print(getCurrentIndex())
    }

    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let currentIndex = Int(self.collectionView.contentOffset.x / self.collectionView.frame.size.width)
//        collectionViewArray[currentIndex].viewWillAppear(true)
//        switch currentIndex {
//        case 0:
//            topBar.settingsButton.isEnabled = true
//            topBar.changeTintForButtons()
//            break
//        case 1:
//            topBar.profileButton.isEnabled = true
//            topBar.changeTintForButtons()
//            break
//        case 2:
//            topBar.pickedAnimalsButton.isEnabled = true
//            topBar.changeTintForButtons()
//            break
//        default:
//            break
//        }
        
        print(getCurrentIndex())
        
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
