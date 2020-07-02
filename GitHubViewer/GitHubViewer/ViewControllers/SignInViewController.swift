//
//  SignInViewController.swift
//  GitHubViewer
//
//  Created by Ksenia on 30.06.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

  // MARK: - Public properties

  // MARK: - Outlets

  // MARK: - Private properties

  // MARK: - View controller view's lifecycle

  var signInView = SignInView()

  override func loadView() {
      view = signInView
  }
  override func viewDidLoad() {
    super.viewDidLoad()
//    view.backgroundColor = .purple
    signInView.didButtonTapped = { [weak self] button in
      self?.signInButtonTapped(button)
    }
  }

  // MARK: - Navigation

  // MARK: - Actions

  // MARK: - Public API

  // MARK: - Private API

  private func signInButtonTapped(_ sender: UIButton) {
    print("Sign In")
  }
}
