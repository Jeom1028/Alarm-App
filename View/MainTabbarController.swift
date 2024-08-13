//
//  MainTabbarController.swift
//  Alarm App
//
//  Created by 강유정 on 8/12/24.
//

import UIKit

class MainTabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
    }
    
    // Tabbar 생성 - YJ
    func setupTabbar() {
        
        let firstTab = UINavigationController(rootViewController: WorldClockController())
        let secondTab = UINavigationController(rootViewController: AlarmController())
        let thirdTab = StopwatchController()
        let fourthTab = TimerController()
        
        firstTab.tabBarItem = UITabBarItem(title: "세계지도", image: UIImage(named: "tabBarWorldClock"), tag: 0)
        secondTab.tabBarItem = UITabBarItem(title: "알람", image: UIImage(named: "tabBarAlarm"), tag: 1)
        thirdTab.tabBarItem = UITabBarItem(title: "스톱워치", image: UIImage(named: "tabBarStopWatch"), tag: 2)
        fourthTab.tabBarItem = UITabBarItem(title: "타이머", image: UIImage(named: "tabBarTimer"), tag: 3)
        
        viewControllers = [firstTab, secondTab, thirdTab, fourthTab]
        
        tabBar.backgroundColor = .black // 탭바 색상
        tabBar.tintColor = .olveDrab    // 선택된 색상
        tabBar.unselectedItemTintColor = .lightGray // 선택안된 색상
        tabBar.isTranslucent = false
        
        selectedIndex = 1
    }
}
