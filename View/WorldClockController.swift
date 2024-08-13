//
//  123.swift
//  Alarm App
//
//  Created by t2023-m0117 on 8/12/24.
//

import UIKit
import SnapKit

class WorldClockController: UIViewController {
  private let tableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    configureUi()
  }
  
  func configureUi() {
    view.addSubview(tableView)
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(WorldClockTableCell.self, forCellReuseIdentifier: "WorldClockTableCell")
    tableView.backgroundColor = .white
    tableView.separatorStyle = .singleLine
    tableView.separatorColor = .darkGray
    
    tableView.snp.makeConstraints {
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

extension WorldClockController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorldClockTableCell", for: indexPath) as? WorldClockTableCell else {
      return UITableViewCell()
    }
    cell.backgroundColor = .white
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = .white
    
    let headerLabel = UILabel()
    headerLabel.text = "세계 시계"
    headerLabel.textColor = .black
    headerLabel.font = UIFont.boldSystemFont(ofSize: 40)
    
    headerView.addSubview(headerLabel)
    
    headerLabel.snp.makeConstraints {
      $0.leading.equalTo(headerView).offset(10)
    }
    return headerView
  }
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
}

