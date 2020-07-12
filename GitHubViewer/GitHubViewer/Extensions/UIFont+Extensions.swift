//
//  UIFont+Extensions.swift
//  GitHubViewer
//
//  Created by Ksenia on 10.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import UIKit

extension UIFont {

  enum FontFamily: String {
    case helveticaNeue = "HelveticaNeue"
  }

  enum FontStyle: String {
    case medium = "Medium"
    case regular = "Regular"
    case bold = "Bold"
    case semibold = "Semibold"
    case light = "Light"
  }

  static func getCustomFont(_ family: FontFamily, _ style: FontStyle? = nil, _ size: CGFloat) -> UIFont {
    var fontName = family.rawValue
    fontName += style != nil ? "-\(style?.rawValue ?? "")" : ""
    guard let font = UIFont(name: fontName, size: size) else {
      fatalError("\(#function); There is no such font!")
    }
    return font
  }
}

extension UIFont {

  static let defaultFont = UIFont.getCustomFont(.helveticaNeue, nil, 16.0)
  static let defaultSmallFont = UIFont.getCustomFont(.helveticaNeue, nil, 12.0)
  static let defaultBoldFont = UIFont.getCustomFont(.helveticaNeue, .bold, 16.0)
  static let defaultNavigationBarFont = UIFont.getCustomFont(.helveticaNeue, .bold, 20.0)
}
