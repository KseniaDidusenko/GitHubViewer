//
//  AppCoordinator.swift
//  GitHubViewer
//
//  Created by Ksenia on 07.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import UIKit

private let kUserRegisteredKey = (Bundle.main.bundleIdentifier ?? "") + ".UserRegistered"

class AppCoordinator: Coordinator {

    // MARK: - Public properties

    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    let window: UIWindow

    // MARK: - Private properties

    private var isFirstStart: Bool {
        PersistentDataManager.shared().isFirstStart ?? true
    }

    // MARK: - Initializer

    init(navController: UINavigationController, window: UIWindow) {
        self.navigationController = navController
        self.navigationController.isNavigationBarHidden = true
        self.window = window
    }

    // MARK: - Public API

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        runApplication()
    }

    func signUp() {
        let signUpCoordinator = SignInCoordinator(navController: navigationController)
        signUpCoordinator.parentCoordinator = self
        childCoordinators.append(signUpCoordinator)
        signUpCoordinator.start()
    }

    func startMain() {
        let mainCoordinator = MainCoordinator(navController: navigationController)
        mainCoordinator.parentCoordinator = self
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }

    // MARK: - Private API

    private func runApplication() {
      if isFirstStart {
        signUp()
        } else {
        startMain()
        }

    }
}
