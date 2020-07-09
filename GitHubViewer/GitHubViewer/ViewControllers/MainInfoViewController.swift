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


  let cellIdentifier = "cellIdentifier"
  var userInfoView = UIView()

  // MARK: - Outlets

  // MARK: - Private properties

  private let tableView = UITableView()
  private var repositiesData = [RepositoryModel]()

  // MARK: - View controller view's lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    getData()
    getRepositories()
  }

  // MARK: - Navigation

  // MARK: - Actions

  // MARK: - Public API

  // MARK: - Private API

  private func addCustomView(userData: UserModel) {
    userInfoView = UserInfoView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 180), data: userData)
    view.addSubview(userInfoView)
    setupTableView()
  }

  private func getData() {
    GitHubService().getUserProfile(accessToken: PersistentDataManager.shared().token ?? "") { [weak self] result  in
      guard let self = self else { return }
      switch result {
      case .success(let user):
        self.addCustomView(userData: user)
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }

  private func setupTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(userInfoView.snp.bottom)
    }
    tableView.tableFooterView = UIView()
    tableView.allowsSelection = true
    tableView.register(RepositoryCell.self, forCellReuseIdentifier: cellIdentifier)
  }

  private func getRepositories() {
    GitHubService().getRepositories(sort: .updated, direction: .desc) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let data):
        self.repositiesData = data
        self.tableView.reloadData()
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
}

extension MainInfoViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return repositiesData.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RepositoryCell else { return UITableViewCell() }
    //    cell.updateTableClosure = { tableView.reloadData() }
    cell.setupCell(repositiesData[indexPath.row])
    return cell
  }
}

extension MainInfoViewController: UITableViewDelegate { }
