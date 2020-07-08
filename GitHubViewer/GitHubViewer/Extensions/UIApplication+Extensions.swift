//
//  UIApplication+Extensions.swift
//  GitHubViewer
//
//  Created by Ksenia on 06.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import UIKit

extension UIApplication {

private static let rootViewAnimationDuration: TimeInterval = 0.5

static func `switch`(on window: UIWindow, to optionalViewController: UIViewController?, animated: Bool = false) {
    guard let viewController = optionalViewController else { return }
    window.rootViewController?.dismiss(animated: false, completion: nil)
    if animated {
        UIView.transition(with: window, duration: rootViewAnimationDuration,
                          options: .transitionFlipFromRight,
                          animations: { window.rootViewController = viewController })
    } else {
        window.rootViewController = viewController
    }
}
}
