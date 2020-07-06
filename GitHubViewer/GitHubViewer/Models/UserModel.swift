//
//  UserModel.swift
//  GitHubViewer
//
//  Created by Ksenia on 06.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import Foundation

struct UserModel: Codable {
  let id: Int
  var login: String
  var email: String?
  var avatarUrl: String?
  var bio: String?

  enum CodingKeys: String, CodingKey {
    case id
    case login
    case email
    case avatarUrl = "avatar_url"
    case bio
  }
}

