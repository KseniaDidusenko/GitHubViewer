//
//  UIColor+Extensions.swift
//  GitHubViewer
//
//  Created by Ksenia on 02.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import UIKit

extension UIColor {

  convenience init(hexString: String) {
    let hex = hexString
      .trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
      .lowercased()
    var int = UInt64()
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
      (r, g, b, a) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17, 255)
    case 6: // RGB (24-bit)
      (r, g, b, a) = (int >> 16, int >> 8 & 0xFF, int & 0xFF, 255)
    case 8: // RGBA (32-bit)
      (r, g, b, a) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF, int >> 24)
    default:
      (r, g, b, a) = (0, 0, 0, 255)
    }
    self.init(r: Int(r), g: Int(g), b: Int(b), a: CGFloat(a))
  }

  convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1) {
    let alpha = (max(0, min(a, 1)))
    let red = CGFloat(max(0, min(r, 255))) / 255
    let green = CGFloat(max(0, min(g, 255))) / 255
    let blue = CGFloat(max(0, min(b, 255))) / 255
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
