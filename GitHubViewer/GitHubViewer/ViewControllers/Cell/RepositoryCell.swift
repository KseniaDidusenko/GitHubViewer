//
//  RepositoryCell.swift
//  GitHubViewer
//
//  Created by Ksenia on 09.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {

  // MARK: - Public properties

  // MARK: - Private properties

  private let repositoryNameLabel : UILabel = {
    let label = UILabel()
    label.textColor = UIColor(hexString: "005cc5")
    label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
    label.textAlignment = .left
    label.numberOfLines = 0
    return label
  }()

  private let lastUpdateLabel : UILabel = {
    let label = UILabel()
    label.textColor = UIColor(hexString: "444d56")
    label.font = UIFont(name: "HelveticaNeue", size: 14)
    label.textAlignment = .right
    label.numberOfLines = 0
    return label
  }()

  private let languageLabel : UILabel = {
    let label = UILabel()
    label.textColor = UIColor(hexString: "444d56")
    label.font = UIFont(name: "HelveticaNeue", size: 14)
    label.textAlignment = .left
    label.numberOfLines = 0
    return label
  }()

  // MARK: - Actions

  // MARK: - Public API

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    createSubviews()
  }

  func setupCell(_ repository: RepositoryModel) {
    repositoryNameLabel.text = repository.name
    languageLabel.text = repository.language
    lastUpdateLabel.text = repository.lastUpdate
  }

  // MARK: - Private API

  private func createSubviews() {
    addSubview(repositoryNameLabel)
    addSubview(lastUpdateLabel)
    addSubview(languageLabel)
    applyLayout()
  }

  private func applyLayout() {
    repositoryNameLabel.snp.makeConstraints { make in
      make.leading.trailing.top.equalToSuperview().inset(10)
    }
    repositoryNameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
    repositoryNameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
    languageLabel.snp.makeConstraints { make in
      make.leading.equalTo(repositoryNameLabel)
      make.top.equalTo(repositoryNameLabel.snp.bottom).offset(10)
      make.bottom.equalToSuperview().inset(10)
    }
    languageLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
    languageLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
    lastUpdateLabel.snp.makeConstraints { make in
      make.trailing.equalTo(repositoryNameLabel.snp.trailing)
      make.leading.equalTo(languageLabel.snp.trailing).offset(10)
      make.centerY.equalTo(languageLabel)
    }
    lastUpdateLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
    lastUpdateLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
  }
}
