//
//  Coordinator.swift
//  GitHubViewer
//
//  Created by Ksenia on 07.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var parentCoordinator: Coordinator? { get set }

    func start()

    func childDidFinish(_ child: Coordinator?)
}

extension Coordinator {

    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
    }
}
