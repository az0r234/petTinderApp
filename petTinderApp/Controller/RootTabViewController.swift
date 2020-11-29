//
//  RootTabViewController.swift
//  Tinderbar
//
//  Created by Merrick Sapsford on 22/10/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit
import Tabman
import Pageboy
import LBTATools


class RootTabViewController: TabmanViewController, ProfileViewControllerProtocol{
    
    enum Tab: String, CaseIterable {
        case profile
        case matches
        case messages
    }
    
    
    let settingsVC = SettingsViewController()
    let profileVC = ProfileViewController()
    let chatVC = ChatViewController()
    
    private let tabItems = Tab.allCases.map({ BarItem(for: $0) })
    private lazy var viewControllers = [settingsVC, profileVC, chatVC]
    let bar = TinderBar.make()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        profileVC.delegate = self
        isScrollEnabled = true
        addBar(bar, dataSource: self, at: .top)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        let darkView = UIView()
        darkView.backgroundColor = .black
        view.addSubview(darkView)
        darkView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: -1, right: 0))
    }
    
    func settingsDidGoUp() {
        bar.isUserInteractionEnabled = false
        isScrollEnabled = false
    }
    
    func settingsDidGoDown() {
        bar.isUserInteractionEnabled = true
        isScrollEnabled = true
    }
}

// MARK: PageboyViewControllerDataSource
extension RootTabViewController: PageboyViewControllerDataSource{
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: 1)
    }
}

// MARK: TMBarDataSource
extension RootTabViewController: TMBarDataSource{
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return tabItems[index]
    }
}

private class BarItem: TMBarItemable {
    var badgeValue: String?
    
    let tab: RootTabViewController.Tab
    
    init(for tab: RootTabViewController.Tab) {
        self.tab = tab
    }
    
    private var _title: String? {
        return tab.rawValue.capitalized
    }
    var title: String? {
        get {
            return _title
        } set {}
    }
    
    private var _image: UIImage? {
        return UIImage(named: "ic_\(tab.rawValue)")
    }
    var image: UIImage? {
        get {
            return _image
        } set {}
    }
}
