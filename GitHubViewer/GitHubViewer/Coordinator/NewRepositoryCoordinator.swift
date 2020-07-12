//
//  NewRepositoryCoordinator.swift
//  GitHubViewer
//
//  Created by Ksenia on 12.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import UIKit

class NewRepositoryCoordinator: Coordinator {

  // MARK: - Public properties

  var navigationController: UINavigationController
  var childCoordinators: [Coordinator] = []
  weak var parentCoordinator: Coordinator?
  var owner: String?

  // MARK: - Private properties

  // MARK: - Initializer

  init(navController: UINavigationController) {
    self.navigationController = navController
  }

  // MARK: - Public API

  func start() {
    newRepository(owner)
  }

  // MARK: - Private API

  private func didFinishRepositoryDetails() {
    parentCoordinator?.childDidFinish(self)
  }

  private func newRepository(on window: UIWindow? = nil, _ owner: String?) {
    let newRepositoryViewController = NewRepositoryViewController()
    newRepositoryViewController.coordinatorNewRepository = self
    newRepositoryViewController.owner = owner
    newRepositoryViewController.view.backgroundColor = .white
    newRepositoryViewController.navigationItem.title = "New Repository"
    navigationController.pushViewController(newRepositoryViewController, animated: true)
  }
}
