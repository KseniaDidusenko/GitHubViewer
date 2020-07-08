//
//  MainInfoViewController.swift
//  GitHubViewer
//
//  Created by Ksenia on 08.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import UIKit
import SnapKit

class MainInfoViewController: UIViewController {

  // MARK: - Public properties

  weak var coordinatorMain: MainCoordinator?

  // MARK: - Outlets

  // MARK: - Private properties

  // MARK: - View controller view's lifecycle

  //  override func loadView() {
  ////      addUserInfoView()
  //  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    getData()
  }

  // MARK: - Navigation

  // MARK: - Actions

  // MARK: - Public API

  // MARK: - Private API

  private func addUserInfoView(userData: UserModel) {
    let viewInfo = UIView(frame: .zero)
    view.addSubview(viewInfo)
    let userInfoView = UserInfoView(frame: .zero, data: userData)
    viewInfo.snp.makeConstraints { make in
      make.trailing.top.leading.equalToSuperview()
      make.height.equalTo(150)
    }
    viewInfo.addSubview(userInfoView)
  }

  private func getData() {
    GitHubService().getUserProfile(accessToken: PersistentDataManager.shared().token ?? "") { [weak self] result  in
      guard let self = self else { return }
      switch result {
      case .success(let user):
        print(user)
        self.addUserInfoView(userData: user)
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
}
