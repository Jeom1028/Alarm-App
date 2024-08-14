//
//  ViewController.swift
//  Alarm App
//
//  Created by t2023-m0117 on 8/12/24.
//

import UIKit

class AlarmController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar()
    }
    
    //MARK: - 바 버튼을 설정하는 메서드 - YJ
    private func setupNavigationBar() {
        self.title = "알람"
        // 네비게이션 바 타이틀 색상 설정
         let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.forestGreen ]
         navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        // 오른쪽 바 버튼에 플러스 아이콘 추가
        let plusImage = UIImage(systemName: "plus")
        let rightBarButton = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(plusButtonTapped))
        // 아이콘 색상 설정
        rightBarButton.tintColor = .brown
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    //MARK: - 오른쪽 바 버튼이 눌렸을 때 호출되는 메서드 - YJ
    @objc func plusButtonTapped() {
        let NavigationController = UINavigationController(rootViewController: AlarmModalController())
        NavigationController.modalPresentationStyle = .formSheet // 모달 크기 설정
        present(NavigationController, animated: true, completion: nil)
    }
}
