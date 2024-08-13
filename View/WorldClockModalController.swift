//
//  WorldTimeModalController.swift
//  Alarm App
//
//  Created by t2023-m0102 on 8/14/24.
//

import Foundation
import UIKit
import SnapKit

class WorldClockModalController: UIViewController {
  let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "검색"
    searchBar.backgroundImage = UIImage()
    return searchBar
  }()
  
  let CancleButton: UIButton = {
    let button = UIButton()
    button.setTitle("취소", for: .normal)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .white
    tableView.separatorStyle = .singleLine
    tableView.separatorColor = .darkGray
    tableView.register(CountriesListCell.self, forCellReuseIdentifier: "CountriesListCell")
    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    self.navigationItem.title = "도시 선택"
    
    configureUI()
  }
  private func configureUI() {
    
    tableView.delegate = self
    tableView.dataSource = self
    
    view.addSubview(searchBar)
    view.addSubview(CancleButton)
    view.addSubview(tableView)
    
    searchBar.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
    }
    
    CancleButton.snp.makeConstraints {
      $0.centerY.equalTo(searchBar)
      $0.leading.equalTo(searchBar.snp.trailing).offset(10)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
    }
    
    tableView.snp.makeConstraints {
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
      $0.top.equalTo(searchBar.snp.bottom).offset(10)
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

extension WorldClockModalController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountriesListCell", for: indexPath) as? CountriesListCell else {
      return UITableViewCell()
    }
    cell.backgroundColor = .white
    return cell
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
}
