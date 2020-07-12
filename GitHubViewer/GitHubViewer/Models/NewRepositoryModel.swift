//
//  NewRepositoryModel.swift
//  GitHubViewer
//
//  Created by Ksenia on 12.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import Foundation

struct NewRepositoryModel: Codable {

  var name: String?
  var description: String?
  var privacy: Bool?
  var gitignoreTemplate: String?
  var licenseTemplate: String?

  enum CodingKeys: String, CodingKey {
    case name
    case description
    case privacy = "private"
    case gitignoreTemplate = "gitignore_template"
    case licenseTemplate = "license_template"
  }
}
