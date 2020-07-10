//
//  TokenModel.swift
//  GitHubViewer
//
//  Created by Ksenia on 06.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import Foundation

struct TokenModel: Codable {
  let accessToken: String
//  let tokenType: String
//  let scope: String

  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
//    case tokenType = "token_type"
//    case scope = "scope"
  }
}
