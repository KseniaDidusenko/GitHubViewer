//
//  LicenseModel.swift
//  GitHubViewer
//
//  Created by Ksenia on 12.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import Foundation

struct LicenseModel: Codable {

  var key: String?
  var name: String?
  var spdxId: String?
  var url: String?
  var nodeId: String?

  enum CodingKeys: String, CodingKey {
    case key
    case name
    case spdxId = "spdx_id"
    case url
    case nodeId = "node_id"
  }
}
