//
//  PersistentDataManager.swift
//  GitHubViewer
//
//  Created by Ksenia on 06.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import Foundation
import KeychainAccess

class PersistentDataManager {

  // MARK: - Singleton

  class func shared() -> PersistentDataManager {
    PersistentDataManager.sharedInstance
  }

  // MARK: - Private Properties

  private static let tokenKey: String = "token"

  private static let sharedInstance = PersistentDataManager()
  private let keychain: Keychain
  private let defaults = UserDefaults.standard

  // MARK: - Public Properties

  var isFirstStart: Bool? {
    get { UserDefaults.standard.get(.isFirstStart) }
    set { UserDefaults.standard.set(newValue, for: .isFirstStart) }
  }

  var token: String? {
    return keychain[PersistentDataManager.tokenKey]
  }

  // MARK: - Initializaers

  private init() {
    self.keychain = Keychain(service: "GitHubViewer-Keychain")
  }

  // MARK: - Public API

  func saveToken(_ token: String) {
    keychain[PersistentDataManager.tokenKey] = token
  }

  @discardableResult
  func clearToken() -> Bool {
    return (try? self.keychain.remove(PersistentDataManager.tokenKey)) != nil
  }

  // MARK: - Private API

}
