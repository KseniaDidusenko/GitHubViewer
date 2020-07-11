//
//  RepositoryDetailsCoordinator.swift
//  GitHubViewer
//
//  Created by Ksenia on 09.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import UIKit

class RepositoryDetailsCoordinator: Coordinator {

  // MARK: - Public properties

  var navigationController: UINavigationController
  var childCoordinators: [Coordinator] = []
  weak var parentCoordinator: Coordinator?
  var repository: RepositoryModel?
  var languages: NSMutableString?

  // MARK: - Private properties

  // MARK: - Initializer

  init(navController: UINavigationController) {
    self.navigationController = navController
  }

  // MARK: - Public API

  func start() {
    repository(repository, languages)
  }

  // MARK: - Private API

  private func didFinishRepositoryDetails() {
    parentCoordinator?.childDidFinish(self)
  }

  private func repository(on window: UIWindow? = nil, _ repository: RepositoryModel?, _ languages: NSMutableString?) {
    let repositoryDetailViewController = RepositoryDetailsViewController()
    repositoryDetailViewController.coordinatorRepository = self
    repositoryDetailViewController.repository = repository
    repositoryDetailViewController.languages = languages
    repositoryDetailViewController.view.backgroundColor = .white
    repositoryDetailViewController.navigationItem.title = "Repository Details"
    navigationController.pushViewController(repositoryDetailViewController, animated: true)
  }
}
