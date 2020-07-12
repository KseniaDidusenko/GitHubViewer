//
//  Data+Extensions.swift
//  GitHubViewer
//
//  Created by Ksenia on 12.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import Alamofire
import Foundation

extension Data {

  func jsonDictionary(_ data: Data, _ options: JSONSerialization.ReadingOptions = .allowFragments) -> [String: Any]? {
    let params = (try? JSONSerialization.jsonObject(with: data, options: options) as? [String: Any])
    return params
  }
}
