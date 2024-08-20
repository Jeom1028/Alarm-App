//
//  ViewController.swift
//  Alarm App
//
//  Created by t2023-m0117 on 8/12/24.
//

import UIKit
import RxSwift
import SnapKit
import CoreData

class AlarmController: UIViewController {
    
    private var alarms: [Alarm] = []
    private let viewModel = AlarmViewModel()
    private let disposeBag = DisposeBag()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .darkGray
        tableView.register(AlarmMainCell.self, forCellReuseIdentifier: AlarmMainCell.id)
//        // 테이블 뷰의 자동 높이 설정
//         tableView.rowHeight = UITableView.automaticDimension
//         tableView.estimatedRowHeight = 100 // 예측 높이 (옵션)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tabBarController?.tabBar.barTintColor = .black // 원하는 색상으로 변경
        
        setupNavigationBar()
        setupHeaderView()
        setupTableView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 최신 알람 데이터를 가져와서 테이블 뷰를 업데이트
        viewModel.fetchAlarms()
//        // 모든 알람 삭제
//         CoreDataManager.shared.delete(entityName: Alarm.className, predicate: NSPredicate(value: true), ofType: Alarm.self)
            
    }
    
    // MARK: - Navigation Bar 설정
    private func setupNavigationBar() {
        
        let leftBarButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editButtonTapped))
        leftBarButton.tintColor = .brown
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let plusImage = UIImage(systemName: "plus")
        let rightBarButton = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(plusButtonTapped))
        rightBarButton.tintColor = .brown
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    // MARK: - 왼쪽 바 버튼이 눌렸을 때 호출되는 메서드
    @objc private func editButtonTapped() {
        let isEditing = tableView.isEditing
         tableView.setEditing(!isEditing, animated: true)
         let buttonTitle = isEditing ? "편집" : "완료"
         self.navigationItem.leftBarButtonItem?.title = buttonTitle
    }
    
    // MARK: - 오른쪽 바 버튼이 눌렸을 때 호출되는 메서드
    @objc private func plusButtonTapped() {
        let navigationController = UINavigationController(rootViewController: AlarmModalController())
        navigationController.modalPresentationStyle = .formSheet
        present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - TableView 설정
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - 헤더 뷰 설정 - YJ
     private func setupHeaderView() {
         let headerView = AlarmHeaderView()
         headerView.frame.size = CGSize(width: tableView.frame.width, height: 60) // 헤더 뷰의 크기 조정
         tableView.tableHeaderView = headerView
     }
    
    // MARK: - 바인딩하는 메서드 - YJ
    private func bindViewModel() {
        viewModel.alarms
            .bind(to: tableView.rx.items(cellIdentifier: AlarmMainCell.id, cellType: AlarmMainCell.self)) { _, alarm, cell in
                cell.configure(with: alarm)
            }
            .disposed(by: disposeBag)
        
        viewModel.alarms.subscribe(onNext: { updatedAlarms in
            // tableView reload
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    
        // RxSwift로 삭제 버튼 액션 설정
        tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                print("Deleting item at indexPath: \(indexPath)")
                self.viewModel.deleteAlarm(at: indexPath.row)
            })
            .disposed(by: disposeBag)
    }
}
