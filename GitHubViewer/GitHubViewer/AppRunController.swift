//
//  AppRunController.swift
//  GitHubViewer
//
//  Created by Ksenia on 06.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import UIKit

class AppRunController {

  // MARK: - Singleton

  private static let sharedInstance = AppRunController()

  private init() { }

  class func shared() -> AppRunController { return self.sharedInstance }

  // MARK: - Public properties

  // MARK: - Private properties

  // MARK: - Public API

  func runApplication() {
//    if (PersistentDataManager.shared().isFirstStart ?? true) {
//      UIApplication.switch(on: <#UIWindow#>, to: .signInViewController())
//    } else {
//      UIApplication.switch(on: <#UIWindow#>, to: .mainInfoViewController())
//    }
  }
  // MARK: - Private API

}
