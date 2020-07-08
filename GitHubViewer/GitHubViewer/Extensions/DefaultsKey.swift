//
//  DefaultsKey.swift
//  GitHubViewer
//
//  Created by Ksenia on 06.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import Foundation

public enum DefaultsKey: String {
  case login
  case isFirstStart
}

extension DefaultsKey {

  static var keys: [DefaultsKey] {
    return [
      .login,
      .isFirstStart
    ]
  }
}
