//
//  LanguageModel.swift
//  GitHubViewer
//
//  Created by Ksenia on 11.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import Foundation

struct LanguageModel: Codable {

  var c: Int?
  let cSharp: Int?
  var cPP: Int?
  var cSS: Int?
  var dart: Int?
  var go: Int?
  var groovy: Int?
  var hTML: Int?
  var java: Int?
  var javaScript: Int?
  var kotlin: Int?
  var metal: Int?
  var objectiveC: Int?
  var perl: Int?
  var pHP: Int?
  var prolog: Int?
  var python: Int?
  var ruby: Int?
  var shell: Int?
  var swift: Int?

  enum CodingKeys: String, CodingKey {
    case c = "C"
    case cSharp = "C#"
    case cPP = "C++"
    case cSS = "CSS"
    case dart = "Dart"
    case go = "Go"
    case groovy = "Groovy"
    case hTML = "HTML"
    case java = "Java"
    case javaScript = "JavaScript"
    case kotlin = "Kotlin"
    case metal = "Metal"
    case objectiveC = "Objective-C"
    case perl = "Perl"
    case pHP = "PHP"
    case prolog = "Prolog"
    case python = "Python"
    case ruby = "Ruby"
    case shell = "Shell"
    case swift = "Swift"
  }
}
