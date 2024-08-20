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
  private var viewModel: WorldClockModalViewModel!
  private let onCitySelected: (String, String) -> Void
  
  let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "검색"
    searchBar.backgroundImage = UIImage()
    return searchBar
  }()
  
  lazy var cancelButton: UIButton = {
    let button = UIButton()
    button.setTitle("취소", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .white
    tableView.separatorStyle = .singleLine
    tableView.separatorColor = .darkGray
    tableView.register(CountriesListTableViewCell.self, forCellReuseIdentifier: "CountriesListCell")
    return tableView
  }()
  
  init(viewModel: WorldClockModalViewModel, onCitySelected: @escaping (String, String) -> Void) {
    self.viewModel = viewModel
    self.onCitySelected = onCitySelected
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    configureUI()
  }
  
  private func configureUI() {
    self.navigationItem.title = "도시 선택"
    
    tableView.delegate = self
    tableView.dataSource = self
    searchBar.delegate = self
    
    view.addSubview(searchBar)
    view.addSubview(cancelButton)
    view.addSubview(tableView)
    
    searchBar.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
    }
    
    cancelButton.snp.makeConstraints {
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
  
  @objc private func cancelButtonTapped() {
    dismiss(animated: true, completion: nil)
  }
}

extension WorldClockModalController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    viewModel.search(for: searchText)
    tableView.reloadData()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
}

extension WorldClockModalController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfItems()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountriesListCell", for: indexPath) as? CountriesListTableViewCell else {
      return UITableViewCell()
    }
    let info = viewModel.item(at: indexPath.row)
    let cityName = String(info.timeZone.split(separator: "/").last ?? "")
    cell.textLabel?.text = cityName
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedInfo = viewModel.item(at: indexPath.row)
    let cityName = String(selectedInfo.timeZone.split(separator: "/").last ?? "")
    let timeZone = selectedInfo.timeZone
    
    onCitySelected(cityName, timeZone)
    dismiss(animated: true, completion: nil)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
}
