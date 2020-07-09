//
//  RepositoryModel.swift
//  GitHubViewer
//
//  Created by Ksenia on 09.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import Foundation

struct RepositoryModel: Codable {

  let name: String?
  var lastUpdate: String?
  var language: String?

  enum CodingKeys: String, CodingKey {
    case name
    case lastUpdate = "pushed_at"
    case language
  }
}
