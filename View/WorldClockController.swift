//
//  123.swift
//  Alarm App
//
//  Created by t2023-m0117 on 8/12/24.
//

import UIKit
import SnapKit

class WorldClockController: UIViewController {
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .white
    tableView.separatorStyle = .singleLine
    tableView.separatorColor = .darkGray
    tableView.register(WorldClockTableCell.self, forCellReuseIdentifier: "WorldClockTableCell")
    return tableView
  }()
  
  lazy var addButton: UIBarButtonItem = {
    let button = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addButtonTapped))
    return button
  }()
  
  lazy var editButton: UIBarButtonItem = {
    let button = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editButtonTapped))
    return button
  }()
  
  private var viewModel = WorldClockViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    configureUI()
  }
  
  private func configureUI() {
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
    
    self.navigationItem.rightBarButtonItem = addButton
    self.navigationItem.leftBarButtonItem = editButton
    
    tableView.snp.makeConstraints {
      $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  @objc private func addButtonTapped() {
    let countriesListViewModel = CountriesListViewModel()
    let worldClockModalViewModel = WorldClockModalViewModel(countriesListViewModel: countriesListViewModel)
    let worldClockModalController = WorldClockModalController(viewModel: worldClockModalViewModel, onCitySelected: { [weak self] cityName, timeZone in
      self?.viewModel.addClock(cityName: cityName, timeZone: timeZone)
      self?.tableView.reloadData()
    })
    
    let navigationController = UINavigationController(rootViewController: worldClockModalController)
    navigationController.modalPresentationStyle = .formSheet
    present(navigationController, animated: true, completion: nil)
  }
  
  @objc private func editButtonTapped() {
    print("여긴 나중에...")
  }
}

extension WorldClockController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfItems()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorldClockTableCell", for: indexPath) as? WorldClockTableCell else {
      return UITableViewCell()
    }
    
    let clockModel = viewModel.clock(at: indexPath.row)
    let currentTime = viewModel.calculateCurrentTime(for: clockModel)
    let ampm = viewModel.calculateAMPM(for: clockModel)
    let timeDifference = viewModel.calculateTimeDifference(for: clockModel)
    
    cell.configure(with: clockModel, currentTime: currentTime, ampm: ampm, timeDifference: timeDifference)
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
      $0.centerY.equalTo(headerView)
    }
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 50
  }
}
