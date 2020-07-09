//
//  GitHubService.swift
//  GitHubViewer
//
//  Created by Ksenia on 03.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import Alamofire
import Foundation

class GitHubService {

  // MARK: - Public properties

  enum GithubConstants: String {
    case clientId = "9fb80b7c8218527e714f"
    case clientSecret = "87b2a893a5ffef45a4aa4692fd210f45d5bb8e65"
    case redirectUrl = "https://github.com"
    case scope = "read:user,user:email,repo,delete_repo"
    case tokenUrl = "/login/oauth/access_token/"
    case userUrl = "/user"
    case repositoryUrl = "/user/repos"
  }

  public enum RepositoriesSort: String {
      case created
      case updated
      case pushed
      case full_name
  }

  public enum RepositoriesDirection: String {
      case asc
      case desc
  }

  // MARK: - Private properties

  private let networkService = NetworkService.shared()
  private let accessToken = PersistentDataManager.shared().token

  // MARK: - Public API

  func getAccessToken(authCode: String, completion: @escaping TokenResultClosure) {

    let grantType = "authorization_code"

    var components = URLComponents()
    components.path = GithubConstants.tokenUrl.rawValue
    components.queryItems = [
      URLQueryItem(name: "grant_type", value: grantType),
      URLQueryItem(name: "code", value: authCode),
      URLQueryItem(name: "client_id", value: GithubConstants.clientId.rawValue),
      URLQueryItem(name: "client_secret", value: GithubConstants.clientSecret.rawValue)
//      URLQueryItem(name: "Accept", value: "application/json")
    ]
//    let parameters = [
//        "grant_type": grantType,
//        "code": authCode,
//        "client_id": GithubConstants.clientId.rawValue,
//        "client_secret": GithubConstants.clientSecret.rawValue
//    ]
    guard let URL = components.url else { return }
    //    // Set the POST parameters.
    //    let postParams = "grant_type=" + grantType + "&code=" + authCode + "&client_id=" + GithubConstants.clientId.rawValue + "&client_secret=" + GithubConstants.clientSecret.rawValue
    //    let postData = postParams.data(using: String.Encoding.utf8)
    //    let request = NSMutableURLRequest(url: URL(string: GithubConstants.tokenUrl.rawValue)!)
    //    request.httpMethod = "POST"
    //    request.httpBody = postData
    //    request.addValue("application/json", forHTTPHeaderField: "Accept")
    var headers = HTTPHeaders()
    headers = [
        "Content-Type" :"text/html; charset=UTF-8",
        //"Content-Type": "application/json",
        //"Content-Type": "application/x-www-form-urlencoded",
        //"Accept": "application/json",
        "Accept": "application/json"
    ]
    networkService.requestAuthorize(apiMethod: URL.absoluteString,
                           method: .post,
                           parameters: nil,
                           headers: headers,
                           responseClass: TokenModel.self) { result in
                            switch result {
                            case .success(let data):
                              completion(.success(data))
                            case .failure(let error):
                              completion(.failure(error))
                            }
    }
  }
  func getUserProfile(accessToken: String, completion: @escaping UserResultClosure) {
//    let verify: NSURL = NSURL(string: tokenURLFull)!
    //      let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
    //      request.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(accessToken)"
    ]
    networkService.request(apiMethod: GithubConstants.userUrl.rawValue,
                           parameters: nil,
                           headers: headers,
                           responseClass: UserModel.self) { result in
                            switch result {
                            case .success(let data):
                              completion(.success(data))
                            case .failure(let error):
                              completion(.failure(error))
                            }
    }
  }

  func getRepositories(sort: RepositoriesSort? = nil, direction: RepositoriesDirection? = nil, completion: @escaping RepositoryResultClosure) {
    var parameters = [String : String]()
    if let sort = sort {
        parameters["sort"] = sort.rawValue
    }
    if let direction = direction {
        parameters["direction"] = direction.rawValue
    }
    let headers: HTTPHeaders = [
      "Authorization": "Bearer \((accessToken) ?? "")"
    ]
    networkService.request(apiMethod: GithubConstants.repositoryUrl.rawValue,
                           parameters: parameters,
                           headers: headers,
                           responseClass: [RepositoryModel].self) { result in
                            switch result {
                            case .success(let data):
                              completion(.success(data))
                            case .failure(let error):
                              completion(.failure(error))
                            }
    }
  }



  // MARK: - Private API

}
