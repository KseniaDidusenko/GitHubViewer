//
//  SignInCoordinator.swift
//  GitHubViewer
//
//  Created by Ksenia on 07.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import UIKit

class SignInCoordinator: Coordinator {

  // MARK: - Public properties

  var navigationController: UINavigationController
  var childCoordinators: [Coordinator] = []
  weak var parentCoordinator: Coordinator?

  // MARK: - Private properties

  // MARK: - Initializer

  init(navController: UINavigationController) {
    self.navigationController = navController
  }

  // MARK: - Public API

  func start() {
    guard let window = (parentCoordinator as? AppCoordinator)?.window else {
      signIn()
      return
    }
    signIn(on: window)
  }

  func showMain() {
    (parentCoordinator as? AppCoordinator)?.startMain()
    didFinishSignUp()
  }

  // MARK: - Private API

  private func didFinishSignUp() {
    parentCoordinator?.childDidFinish(self)
  }

  private func signIn(on window: UIWindow? = nil) {
    let signInViewController = SignInViewController()
    signInViewController.coordinatorSignIn = self
    navigationController.setViewControllers([signInViewController], animated: false)
    navigationController.isNavigationBarHidden = true
    navigationController.navigationBar.isTranslucent = false
    navigationController.navigationBar.topItem?.title = ""
    guard let window = window else { return }
    UIApplication.switch(on: window, to: navigationController, animated: true)
  }
}
