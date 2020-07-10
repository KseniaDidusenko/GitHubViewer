//
//  MainCoordinator.swift
//  GitHubViewer
//
//  Created by Ksenia on 07.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {

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
      showMain()
      return
    }
    showMain(on: window)
  }

  func showRepositoryDetais(repository: RepositoryModel?) {
      repositoryDetails(repository)
  }

  // MARK: - Private API

  private func didFinishMain() {
    parentCoordinator?.childDidFinish(self)
  }

  private func showMain(on window: UIWindow? = nil) {
    let mainViewController = MainInfoViewController()
    mainViewController.coordinatorMain = self
    navigationController.setViewControllers([mainViewController], animated: false)
    navigationController.isNavigationBarHidden = false
    navigationController.navigationBar.isTranslucent = false
    mainViewController.navigationItem.title = "Profile"
    navigationController.navigationBar.barTintColor = UIColor(hexString: "#333333")
    let textAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.white,
      .font: UIFont(name: "HelveticaNeue-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20)
    ]
    navigationController.navigationBar.titleTextAttributes = textAttributes
    guard let window = window else { return }
    UIApplication.switch(on: window, to: navigationController, animated: true)
  }

  private func repositoryDetails(_ repository: RepositoryModel?) {
      let documentsCoordinator = RepositoryDetailsCoordinator(navController: navigationController)
      documentsCoordinator.parentCoordinator = self
      childCoordinators.append(documentsCoordinator)
      documentsCoordinator.repository = repository
      documentsCoordinator.start()
  }
}
