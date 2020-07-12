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
    case deleteRepositoryUrl = "/repos/"
    case gitignoreListUrl = "/gitignore/templates"
    case gitLicenseUrl = "/licenses"
  }

  public enum RepositoriesSort: String {
    case created
    case updated
    case pushed
    case fullName = "full_name"
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
    ]
    guard let URL = components.url else { return }
    var headers = HTTPHeaders()
    headers = [
      "Content-Type": "text/html; charset=UTF-8",
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
    var parameters = [String: String]()
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

  func deleteRepository(fullName: String, completion: @escaping EmptyResultClosure) {
    let headers: HTTPHeaders = [
      "Authorization": "Bearer \((accessToken) ?? "")"
    ]
    networkService.request(apiMethod: GithubConstants.deleteRepositoryUrl.rawValue + fullName,
                           method: .delete,
                           parameters: nil,
                           headers: headers,
                           responseClass: NetworkService.EmptyResponse.self) { result in
                            switch result {
                            case .success:
                              completion(.voidSuccess)
                            case .failure(let error):
                              completion(.failure(error))
                            }
    }
  }

  func getLanguages(fullName: String, completion: @escaping LanguagesResultClosure) {
    let headers: HTTPHeaders = [
      "Authorization": "Bearer \((accessToken) ?? "")"
    ]
    networkService.request(apiMethod: GithubConstants.deleteRepositoryUrl.rawValue + fullName + "/languages",
                           parameters: nil,
                           headers: headers,
                           responseClass: LanguageModel.self) { result in
                            switch result {
                            case .success(let data):
                            completion(.success(data))
                            case .failure(let error):
                              completion(.failure(error))
                            }
    }
  }

  func getGitignoreList(completion: @escaping GitIgnoreResultClosure) {
    networkService.request(apiMethod: GithubConstants.gitignoreListUrl.rawValue,
                           parameters: nil,
                           responseClass: [String].self) { result in
                            switch result {
                            case .success(let data):
                            completion(.success(data))
                            case .failure(let error):
                              completion(.failure(error))
                            }
    }
  }

  func getLicenseList(completion: @escaping LicenseResultClosure) {
    networkService.request(apiMethod: GithubConstants.gitLicenseUrl.rawValue,
                           parameters: nil,
                           responseClass: [LicenseModel].self) { result in
                            switch result {
                            case .success(let data):
                            completion(.success(data))
                            case .failure(let error):
                              completion(.failure(error))
                            }
    }
  }

  func createUser(_ repository: NewRepositoryModel, completion: @escaping NewRepositoryResultClosure) {
    let headers: HTTPHeaders = [
      "Authorization": "Bearer \((accessToken) ?? "")"
    ]
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    guard let data = try? encoder.encode(repository) else {
      completion(.failure(NetworkService.Errors.requestEncodingError))
      return
    }
    guard let params = Data().jsonDictionary(data) else {
      completion(.failure(NetworkService.Errors.requestNotValidJson))
      return
    }
    networkService.request(
      apiMethod: GithubConstants.repositoryUrl.rawValue,
      method: .post,
      parameters: params,
      encoding: JSONEncoding.default,
      headers: headers,
      responseClass: RepositoryModel.self) { result in
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
