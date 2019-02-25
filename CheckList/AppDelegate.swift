//
//  AppDelegate.swift
//  CheckList
//
//  Created by junwoo on 07/02/2019.
//  Copyright © 2019 samchon. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow()
    window?.makeKeyAndVisible()
    let mainViewController = MainViewController()
    window?.rootViewController = UINavigationController(rootViewController: mainViewController)
    return true
  }

  


}

