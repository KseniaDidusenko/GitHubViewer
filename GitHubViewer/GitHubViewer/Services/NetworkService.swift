//
//  NetworkService.swift
//  GitHubViewer
//
//  Created by Ksenia on 03.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import Alamofire
import Foundation
import NotificationBannerSwift

enum Result<T> {
  case success(T)
  case failure(Error)
}

extension Result {
  static var voidSuccess: Result<Void> {
    return .success(())
  }
}

class NetworkService {

  // MARK: - Singleton.

  private static let sharedInstance = NetworkService()

  private init() { }

  class func shared() -> NetworkService { NetworkService.sharedInstance }

  // MARK: - Public properties

  class EmptyResponse: Codable {}

  enum Errors: Error {
    case badRequest
    case responseNotValidJson
    case noDataReturned
    case requestEncodingError
    case requestNotValidJson
    case unknownError
  }

  // MARK: - Private properties

  private let baseURLAuthorize = "https://github.com"
  private let baseURL = "https://api.github.com"

  private var shouldShowNotificationBanner: Bool = true

  // MARK: - Public API

  @discardableResult
  func request<T: Codable>(apiMethod: String,
                           method: HTTPMethod = .get,
                           parameters: Parameters?,
                           encoding: ParameterEncoding = URLEncoding.default,
                           headers: HTTPHeaders? = nil,
                           responseClass: T.Type,
                           completion: @escaping (Result<T>) -> Void) -> DataRequest {
    //    var mergedHeaders = headers ?? HTTPHeaders()
    //    if let token = KeychainManager.shared().accessToken {
    //      mergedHeaders.add(name: tokenKey, value: token)
    //    }
    let request = AF
      .request(urlForApiMethod(apiMethod),
               method: method,
               parameters: parameters,
               encoding: encoding,
               headers: headers)
      .validate(statusCode: 200..<300)
      .responseJSON { response in
        switch response.result {
        case .success:
          guard let data = response.data else {
            self.showBanner(title: "API Error", subtitle: "Server returns no data")
            completion(.failure(Errors.noDataReturned as NSError))
            return
          }
          guard let responseObject = try? JSONDecoder().decode(T.self, from: data) else {
            self.showBanner(title: "API Error", subtitle: "Failed to parse server response")
            completion(.failure(Errors.responseNotValidJson as NSError))
            return
          }
          completion(.success(responseObject))
        case .failure(let error):
          self.handleError(error, using: response.response?.statusCode) { failureResponse in
            completion(failureResponse)
          }
        }
    }
    .cURLDescription(calling: { curl in
      print(curl)
    })
    return request
  }

  func requestAuthorize<T: Codable>(apiMethod: String,
                                    method: HTTPMethod = .get,
                                    parameters: Parameters?,
                                    encoding: ParameterEncoding = URLEncoding.default,
                                    headers: HTTPHeaders? = nil,
                                    responseClass: T.Type,
                                    completion: @escaping (Result<T>) -> Void) -> DataRequest {
    //    var mergedHeaders = headers ?? HTTPHeaders()
    //    if let token = KeychainManager.shared().accessToken {
    //      mergedHeaders.add(name: tokenKey, value: token)
    //    }
    let request = AF
      .request(urlForAuthorize(apiMethod),
               method: method,
               parameters: parameters,
               encoding: encoding,
               headers: headers)
      .validate(statusCode: 200..<300)
      .responseJSON { response in
        switch response.result {
        case .success:
          guard let data = response.data else {
            self.showBanner(title: "API Error", subtitle: "Server returns no data")
            completion(.failure(Errors.noDataReturned as NSError))
            return
          }
          guard let responseObject = try? JSONDecoder().decode(T.self, from: data) else {
            self.showBanner(title: "API Error", subtitle: "Failed to parse server response")
            completion(.failure(Errors.responseNotValidJson as NSError))
            return
          }
          completion(.success(responseObject))
        case .failure(let error):
          self.handleError(error, using: response.response?.statusCode) { failureResponse in
            completion(failureResponse)
          }
        }
    }
    .cURLDescription(calling: { curl in
      print(curl)
    })
    return request
  }

  // MARK: - Private API

  private func handleError<T: Codable>(_ error: Error,
                                       using responseStatusCode: Int? = nil,
                                       completion: @escaping (Result<T>) -> Void) {
    if let responseStatusCode = responseStatusCode {
      switch responseStatusCode {
      case 200...299:
        completion(.success(self.emptyResult()))
        return
      default:
        self.showBanner(title: "API Error", subtitle: error.localizedDescription)
      }
      completion(.failure(self.createError(responseStatusCode)))
    } else {
      switch (error as NSError).code {
      case -999:
        return
      case -1009:
        self.showBanner(title: "No internet connection",
                        subtitle: "The Internet connection appears to be offline")
      default:
        self.showBanner(title: "API Error", subtitle: error.localizedDescription)
      }
      completion(.failure(error))
    }
  }

  private func urlForApiMethod(_ apiMethod: String) -> String { return baseURL + apiMethod }
  private func urlForAuthorize(_ apiMethod: String) -> String { return baseURLAuthorize + apiMethod }

  private func showBanner(title: String, subtitle: String) {
    if !shouldShowNotificationBanner { return }
    let banner = NotificationBanner(title: title, subtitle: subtitle, style: .warning)
    banner.delegate = self
    banner.duration = 3.0
    banner.onTap = { banner.dismiss() }
    banner.show()
  }

  private func createError(_ statusCode: Int) -> NSError {
    return NSError(domain: "github.com", code: statusCode, userInfo: nil)
  }

  private func emptyResult<T>() -> T where T: Decodable {
    // swiftlint:disable force_cast
    return EmptyResponse() as! T
  }
}

extension NetworkService: NotificationBannerDelegate {

  func notificationBannerWillAppear(_ banner: BaseNotificationBanner) { shouldShowNotificationBanner = false }

  func notificationBannerDidAppear(_ banner: BaseNotificationBanner) {}

  func notificationBannerWillDisappear(_ banner: BaseNotificationBanner) { shouldShowNotificationBanner = true }

  func notificationBannerDidDisappear(_ banner: BaseNotificationBanner) {}
}
