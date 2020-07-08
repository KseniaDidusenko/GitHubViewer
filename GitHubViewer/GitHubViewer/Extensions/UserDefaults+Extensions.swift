//
//  UserDefaults+Extensions.swift
//  GitHubViewer
//
//  Created by Ksenia on 06.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import Foundation

extension UserDefaults {

  func get<T>(_ key: DefaultsKey) -> T? {
    return object(forKey: key.rawValue) as? T
  }

  func set(_ value: Any?, for key: DefaultsKey) {
    set(value, forKey: key.rawValue)
  }
}
