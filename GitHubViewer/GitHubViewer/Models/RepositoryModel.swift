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
  var fullName: String?
  var htmlUrl: String?
  var description: String?
  var languagesUrl: String?
  var stargazersCount: Int?
  var forksCount: Int?
  var openIssuesCount: Int?

  enum CodingKeys: String, CodingKey {
    case name
    case lastUpdate = "pushed_at"
    case language
    case fullName = "full_name"
    case htmlUrl = "html_url"
    case description
    case languagesUrl = "languages_url"
    case stargazersCount = "stargazers_count"
    case forksCount = "forks_count"
    case openIssuesCount = "open_issues_count"
  }
}
