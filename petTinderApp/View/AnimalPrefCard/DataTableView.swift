//
//  DataTableView.swift
//  petTinderApp
//
//  Created by Alok Acharya on 11/11/20.
//  Copyright © 2020 Alok Acharya. All rights reserved.
//

import UIKit

protocol OptionSelected {
    func selectedOption(button: ParametersButtons)
}

class DataTableView: UIView {
    let searchBar: UISearchBar = {
        let s = UISearchBar()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.heightAnchor.constraint(equalToConstant: 35).isActive = true
        s.searchBarStyle = .prominent
        s.sizeToFit()
        s.backgroundImage = UIImage()
        return s
    }()
    let tableView: UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.heightAnchor.constraint(equalToConstant: 100).isActive = true
        t.separatorStyle = .none
        return t
    }()
    let goBack = ParametersButtons(leftLabel: K.backBtn, rightLabel: "")
    
    var delegate: OptionSelected?
    var dataDictionary = [String:[String]]()
    var dataSectionTitles = [String]()

    var dataArray : [String]! {
        didSet{
            filteredData = dataArray
        }
    }
    var filteredData : [String]! {
        didSet{
            sortByAlphabeticalOrder(datas: filteredData)
        }
    }
    
    var buttonPressed: ParametersButtons!

    override init(frame: CGRect) {
        super.init(frame: frame)

        tableViewSetup()
        addButtonStackToView()
        searchBar.delegate = self
        print("TAble View INIT")
    }
    
    fileprivate func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }
    
    fileprivate func addButtonStackToView() {
        goBack.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let stackView = UIStackView(arrangedSubviews: [searchBar, tableView, goBack])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 10, left: 15, bottom: 25, right: 15))
    }
    
    fileprivate func sortByAlphabeticalOrder(datas : [String]) {
        dataDictionary.removeAll()
        dataSectionTitles.removeAll()
        for data in datas{
            let dataKey = String(data.prefix(1))
            if var dataValues = dataDictionary[dataKey]{
                dataValues.append(data)
                dataDictionary[dataKey] = dataValues
            }else{
                dataDictionary[dataKey] = [data]
            }
        }
        
        dataSectionTitles = [String](dataDictionary.keys)
        dataSectionTitles = dataSectionTitles.sorted(by: {$0 < $1})
        
        dataSectionTitles.insert(" ", at: dataSectionTitles.startIndex)
        dataDictionary[" "] = ["Random"]
        
        tableView.reloadData()
    } 
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DataTableView: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataKey = dataSectionTitles[section]
        if let dataValue = dataDictionary[dataKey]{
            return dataValue.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) //as! DataTableViewCell
        
        let dataKey = dataSectionTitles[indexPath.section]
        if let dataValue = dataDictionary[dataKey]{
            cell.textLabel?.text = dataValue[indexPath.row]
        }
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cell.textLabel?.textAlignment = .left
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSectionTitles[section]
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return dataSectionTitles
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataKey = dataSectionTitles[indexPath.section]
        guard let dataValue = dataDictionary[dataKey] else {return}
        
        tableView.deselectRow(at: indexPath, animated: true)
        buttonPressed.rightLbl.text = dataValue[indexPath.row]
        delegate?.selectedOption(button: buttonPressed)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension DataTableView: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        filteredData = []

        if searchText == "" {
            filteredData = dataArray
        }else {
            for data in dataArray{
                if data.lowercased().contains(searchText.lowercased()) {
                    filteredData.append(data)
                }
            }
        }
        
        UIView.transition(with: tableView, duration: 0.25, options: .transitionCrossDissolve) {
            self.tableView.reloadData()
        } completion: { (_) in
            
        }

        
        
    }
}
