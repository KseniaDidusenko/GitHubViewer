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
  private var repositoriesData = [RepositoryModel]()
  private var refreshControl = UIRefreshControl()

  // MARK: - View controller view's lifecycle

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getRepositories()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    getData()
    setupNavigationBar()
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    tableView.addSubview(refreshControl) // not required when using UITableViewController
  }
  @objc func refresh(_ sender: AnyObject) {
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
        self.repositoriesData = data
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }

  private func getLanguages(fullName: String, repository: RepositoryModel) {
    GitHubService().getLanguages(fullName: fullName) { [weak self] result in
      guard let self = self else { return }
      switch result {
      case .success(let data):
        let languages = self.getPercentOfLanguages(data)
        self.coordinatorMain?.showRepositoryDetais(repository: repository, languages: languages)
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }

  private func getPercentOfLanguages(_ data: LanguageModel) -> NSMutableString {
    var dictionary = [String: Int]()
    for case let (label?, value) in Mirror(reflecting: data)
      .children.map({ ($0.label, $0.value) }) {
        if let value = value as? Int {
          dictionary[label] = value
        }
    }
    var allAmountOfBytes = 0
    let languages = NSMutableString()
    for (_, value) in dictionary {
      allAmountOfBytes += value
    }
    for (key, value) in dictionary {
      let percent = Float((value * 100)) / Float(allAmountOfBytes)
      let roundedValue = roundf(percent * 10) / 10
      languages.append("\(key.capitalizingFirstLetter()): \(roundedValue)% \n")
    }
    print(languages)
    return languages
  }
}

extension MainInfoViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return repositoriesData.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RepositoryCell else { return UITableViewCell() }
    cell.setupCell(repositoriesData[indexPath.row])
    return cell
  }
}

extension MainInfoViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    getLanguages(fullName: repositoriesData[indexPath.row].fullName ?? "", repository: repositoriesData[indexPath.row])
  }
}
