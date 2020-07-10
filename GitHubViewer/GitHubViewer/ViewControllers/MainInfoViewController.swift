//
//  MainInfoViewController.swift
//  GitHubViewer
//
//  Created by Ksenia on 08.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import SnapKit
import UIKit

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
    setupNavigationBar()
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

  private func setupNavigationBar() {
    let repositoryNewButton = UIButton(type: .custom)
    repositoryNewButton.setImage(UIImage(named: "repository"), for: .normal)
    repositoryNewButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
    repositoryNewButton.addTarget(self, action: #selector(createNewRepository), for: .touchUpInside)
    repositoryNewButton.setTitle("New", for: .normal)
    repositoryNewButton.setTitleColor(.white, for: .normal)
    repositoryNewButton.backgroundColor = UIColor(hexString: "28a745")
    repositoryNewButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16)
    repositoryNewButton.clipsToBounds = true
    repositoryNewButton.layer.cornerRadius = 5
    let item = UIBarButtonItem(customView: repositoryNewButton)
    self.navigationItem.setRightBarButtonItems([item], animated: true)
  }

  @objc func createNewRepository() {
  }

  private func getRepositories() {
    GitHubService().getRepositories(sort: .pushed, direction: .desc) { [weak self] result in
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
    cell.setupCell(repositiesData[indexPath.row])
    return cell
  }
}

extension MainInfoViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    coordinatorMain?.showRepositoryDetais(repository: repositiesData[indexPath.row])
  }
}
