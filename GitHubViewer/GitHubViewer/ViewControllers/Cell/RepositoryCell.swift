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

  private let repositoryNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .repositoryBlue
    label.font = .defaultTitleFont
    label.textAlignment = .left
    label.numberOfLines = 1
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    return label
  }()

  private let lastUpdateLabel: UILabel = {
    let label = UILabel()
    label.textColor = .repositoryLightGray
    label.font = .defaultLabelFont
    label.textAlignment = .right
    label.numberOfLines = 1
    return label
  }()

  private let languageLabel: UILabel = {
    let label = UILabel()
    label.textColor = .repositoryLightGray
    label.font = .defaultLabelFont
    label.textAlignment = .left
    label.numberOfLines = 1
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
    lastUpdateLabel.text = setDateOfLastUpdate(repository.lastUpdate ?? "")
  }

  // MARK: - Private API

  private func setDateOfLastUpdate(_ lastUpdate: String) -> String {
    var updatedAt = String()
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.timeZone = .autoupdatingCurrent
    guard let date = dateFormatter.date(from: lastUpdate) else { return "" }
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM yyyy"
    let componentsFormatter = DateComponentsFormatter()
    let dateComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: date, to: Date())
    componentsFormatter.unitsStyle = .full

    if dateComponents.day ?? 0 > 0 {
      componentsFormatter.allowedUnits = .day
    } else if dateComponents.hour ?? 0 > 0 {
      componentsFormatter.allowedUnits = .hour
    } else if dateComponents.minute ?? 0 > 0 {
      componentsFormatter.allowedUnits = .minute
    } else {
      componentsFormatter.allowedUnits = .second
    }
    if dateComponents.day ?? 0 <= 9 {
      updatedAt = componentsFormatter.string(from: date, to: Date()) ?? ""
    } else if dateComponents.day ?? 0 == 0 {
      updatedAt = componentsFormatter.string(from: date, to: Date()) ?? ""
    } else if dateComponents.day ?? 0 == 0 && dateComponents.hour ?? 0 == 0 {
      updatedAt = componentsFormatter.string(from: date, to: Date()) ?? ""
    } else if dateComponents.day ?? 0 == 0 && dateComponents.hour ?? 0 == 0 && dateComponents.minute ?? 0 == 0 {
      updatedAt = componentsFormatter.string(from: date, to: Date()) ?? ""
    } else {
      updatedAt = formatter.string(from: date)
    }
    return updatedAt
  }

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
