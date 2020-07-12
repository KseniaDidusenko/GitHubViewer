//
//  RepositoryDetailsViewController.swift
//  GitHubViewer
//
//  Created by Ksenia on 09.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import UIKit

class RepositoryDetailsViewController: UIViewController {

  // MARK: - Public properties

  weak var coordinatorRepository: RepositoryDetailsCoordinator?
  var repository: RepositoryModel?
  var languages: NSMutableString?

  // MARK: - Outlets

  // MARK: - Private properties

  private let scrollView: UIScrollView = {
    let v = UIScrollView()
    return v
  }()

  // MARK: - View controller view's lifecycle

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    addCustomView()
    setupNavigationBar()
  }

  // MARK: - Navigation

  // MARK: - Actions

  // MARK: - Public API

  // MARK: - Private API

  private func setupNavigationBar() {
    let shareBarButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
    let moreBarButton = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(moreButtonTapped))
    navigationItem.setRightBarButtonItems([moreBarButton, shareBarButton], animated: true)
  }

  @objc private func shareButtonTapped() {
    guard let repositoryUrl = repository?.htmlUrl else { return }
    let activityController = UIActivityViewController(activityItems: [repositoryUrl], applicationActivities: nil)
    self.present(activityController, animated: true, completion: nil)
  }

  @objc private func moreButtonTapped() {
    let moreAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let action = UIAlertAction(title: "Open in Browser", style: .default) { _ in self.openRepositoryInBrowser() }
    moreAlertController.addAction(action)
    let deleteAction = UIAlertAction(title: "Delete Repository", style: .destructive) { _ in self.showAlert() }
    moreAlertController.addAction(deleteAction)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    moreAlertController.addAction(cancelAction)
    present(moreAlertController, animated: true)
  }

  private func showAlert() {
    let repositoryName = (repository?.fullName) ?? ""
    let alert = UIAlertController(title: "Are you sure?",
                                  message: "This action cannot be undone." +
      " This will permanently delete the \(repositoryName) repository, wiki, issues, comments, packages, secrets, workflow runs, and remove all collaborator associations.",
      preferredStyle: UIAlertController.Style.alert)
    let deleteAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default) { _ in self.deleteRepository() }
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
    alert.addAction(deleteAction)
    alert.addAction(cancelAction)
    self.present(alert, animated: true, completion: nil)
  }

  private func deleteRepository() {
    GitHubService().deleteRepository(fullName: repository?.fullName ?? "") { result in
      switch result {
      case .success:
        let alert = UIAlertController(title: "", message: "Repository successfully deleted.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel) { _ in
          self.navigationController?.popViewController(animated: true)
        })
        self.present(alert, animated: true, completion: nil )
      case .failure(let error):
        self.showAlert(title: "Error", message: error.localizedDescription)
      }
    }
  }

  private func openRepositoryInBrowser() {
    guard let url = URL(string: repository?.htmlUrl ?? "") else { return }
    UIApplication.shared.open(url)
  }

  private func addCustomView() {
    scrollView.delegate = self
    guard let repository = repository else { return }
    guard let languages = languages else { return }
    let repositoryDetailView = RepositoryDetailView(frame: self.view.frame, data: repository, languages: languages)
    scrollView.addSubview(repositoryDetailView)
    view.addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.height.equalTo(repositoryDetailView.snp.height).priority(749)
      make.width.equalTo(repositoryDetailView.snp.width)
    }
    scrollView.showsVerticalScrollIndicator = false
    scrollView.bounces = false
    scrollView.contentInsetAdjustmentBehavior = .automatic
    scrollView.automaticallyAdjustsScrollIndicatorInsets = false
    scrollView.contentInset = UIEdgeInsets.zero
    scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    scrollView.contentOffset = CGPoint(x: 0, y: 0)
    scrollView.contentSize = CGSize(width: repositoryDetailView.bounds.width,
                                    height: repositoryDetailView.bounds.height)
  }
}

extension RepositoryDetailsViewController: UIScrollViewDelegate { }
