//
//  UIViewController+Extensions.swift
//  GitHubViewer
//
//  Created by Ksenia on 06.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import UIKit

extension UIViewController {

//  static func mainInfoViewController() -> UIViewController? {
//    return MainInfoViewController()
//  }
//
//  static func signInViewController() -> UIViewController? {
//    return SignInViewController()
//  }

  func showAlert(title: String = "", message: String = "", buttonTitle: String = "OK") {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: nil))
    present(alert, animated: true, completion: nil )
  }
}
