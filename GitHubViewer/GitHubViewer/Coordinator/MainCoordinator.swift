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

  func showRepositoryDetais(repository: RepositoryModel?, languages: NSMutableString?) {
    repositoryDetails(repository, languages)
  }

  func showNewRepository(owner: String?) {
    newRepository(owner: owner)
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
      .font: UIFont.defaultNavigationBarFont
    ]
    navigationController.navigationBar.titleTextAttributes = textAttributes
    guard let window = window else { return }
    UIApplication.switch(on: window, to: navigationController, animated: true)
  }

  private func repositoryDetails(_ repository: RepositoryModel?, _ languages: NSMutableString?) {
    let repositoryDetailsCoordinator = RepositoryDetailsCoordinator(navController: navigationController)
    repositoryDetailsCoordinator.parentCoordinator = self
    childCoordinators.append(repositoryDetailsCoordinator)
    repositoryDetailsCoordinator.repository = repository
    repositoryDetailsCoordinator.languages = languages
    repositoryDetailsCoordinator.start()
  }

  private func newRepository(owner: String?) {
    let newRepositoryCoordinator = NewRepositoryCoordinator(navController: navigationController)
    newRepositoryCoordinator.parentCoordinator = self
    newRepositoryCoordinator.owner = owner
    childCoordinators.append(newRepositoryCoordinator)
    newRepositoryCoordinator.start()
  }
}
