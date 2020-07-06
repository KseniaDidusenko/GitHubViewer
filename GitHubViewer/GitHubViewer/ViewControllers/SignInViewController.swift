//
//  SignInViewController.swift
//  GitHubViewer
//
//  Created by Ksenia on 30.06.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class SignInViewController: UIViewController {

  // MARK: - Public properties

  // MARK: - Outlets

  // MARK: - Private properties

  var webView = WKWebView()

  // MARK: - View controller view's lifecycle

  var signInView = SignInView()

  override func loadView() {
      view = signInView
  }
  override func viewDidLoad() {
    super.viewDidLoad()
//    view.backgroundColor = .purple
    signInView.didButtonTapped = { [weak self] button in
      self?.signInButtonTapped(button)
    }
  }

  // MARK: - Navigation

  // MARK: - Actions

  // MARK: - Public API

  // MARK: - Private API

  private func signInButtonTapped(_ sender: UIButton) {
    print("Sign In")
    createWebController()
  }

  private func createWebController() {
//    let uuid = UUID().uuidString
//    let authURLFull = "https://github.com/login/oauth/authorize?client_id=" + GitHubService.GithubConstants.clientId.rawValue + "&scope=" + GitHubService.GithubConstants.scope.rawValue + "&redirect_uri=" + GitHubService.GithubConstants.redirectUrl.rawValue + "&state=" + uuid
//
//    let urlRequest = URLRequest(url: URL(string: authURLFull)!)
//    if let url = URL(string: authURLFull) {
//        let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
//        vc.delegate = self
//
//        present(vc, animated: true)
//    }

    let githubVC = UIViewController()
    let uuid = UUID().uuidString
    let webView = WKWebView()
    webView.navigationDelegate = self
    githubVC.view.addSubview(webView)
    webView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    let authURLFull = "https://github.com/login/oauth/authorize?client_id=" + GitHubService.GithubConstants.clientId.rawValue + "&scope=" + GitHubService.GithubConstants.scope.rawValue + "&redirect_uri=" + GitHubService.GithubConstants.redirectUrl.rawValue + "&state=" + uuid
    
    let urlRequest = URLRequest(url: URL(string: authURLFull)!)
    webView.load(urlRequest)

    // Create Navigation Controller
    let navController = UINavigationController(rootViewController: githubVC)
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
    githubVC.navigationItem.leftBarButtonItem = cancelButton
    let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshAction))
    githubVC.navigationItem.rightBarButtonItem = refreshButton
    let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    navController.navigationBar.titleTextAttributes = textAttributes
    githubVC.navigationItem.title = "github.com"
    navController.navigationBar.isTranslucent = false
    navController.navigationBar.tintColor = UIColor.white
    navController.navigationBar.barTintColor = UIColor(hexString: "#333333")
    navController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
    navController.modalTransitionStyle = .coverVertical

    self.present(navController, animated: true, completion: nil)
  }

  @objc func cancelAction() {
      self.dismiss(animated: true, completion: nil)
  }

  @objc func refreshAction() {
      self.webView.reload()
  }

  func requestForCallbackURL(request: URLRequest) {
    let requestURLString = (request.url?.absoluteString)! as String
    print(requestURLString)
    if requestURLString.hasPrefix(GitHubService.GithubConstants.redirectUrl.rawValue) {
      if requestURLString.contains("code=") {
        if let range = requestURLString.range(of: "=") {
          let githubCode = requestURLString[range.upperBound...]
          if let range = githubCode.range(of: "&state=") {
            let githubCodeFinal = githubCode[..<range.lowerBound]
//            githubRequestForAccessToken(authCode: String(githubCodeFinal))
            print(String(githubCodeFinal))
            GitHubService().getAccessToken(authCode: String(githubCodeFinal)) { result in
              switch result {
              case .success(let token):
                print(token)
                GitHubService().getUserProfile(accessToken: token.accessToken) { result in
                        switch result {
                  case .success(let user):
                    print(user)
                  case .failure(let error):
                    print(error.localizedDescription)
                  }
                }
              case .failure(let error):
                print(error.localizedDescription)
              }
            }

            // Close GitHub Auth ViewController after getting Authorization Code
            self.dismiss(animated: true, completion: nil)
          }
        }
      }
    }
  }
}

extension SignInViewController: WKNavigationDelegate {
//  func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
//      dismiss(animated: true)
//  }
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    requestForCallbackURL(request: navigationAction.request)
      decisionHandler(.allow)
  }
}
