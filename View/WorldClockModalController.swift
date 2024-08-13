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

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    self.navigationItem.title = "도시 선택"
    
    configureUI()
  }
  private func configureUI() {
    view.addSubview(searchBar)
    view.addSubview(CancleButton)
    
    searchBar.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
    }
    
    CancleButton.snp.makeConstraints {
      $0.centerY.equalTo(searchBar)
      $0.leading.equalTo(searchBar.snp.trailing).offset(10)
      $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
    }
  }
  
}
