//
//  RepositoryDetailView.swift
//  GitHubViewer
//
//  Created by Ksenia on 10.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import SnapKit
import UIKit

class RepositoryDetailView: UIView {

  // MARK: - Public properties

  // MARK: - Outlets

  // MARK: - Private properties

  private let view: UIView = {
      let view = UIView()
      return view
  }()

  private let repositoryNameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.numberOfLines = 1
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    return label
  }()

  private let repositoryFullNameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.numberOfLines = 1
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.defaultFont
    label.textAlignment = .left
    label.numberOfLines = 0
    label.adjustsFontSizeToFitWidth = true
    return label
  }()

  private let languagesTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.defaultBoldFont
    label.textAlignment = .left
    label.numberOfLines = 1
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    return label
  }()

  private let languagesLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.defaultFont
    label.textAlignment = .left
    label.numberOfLines = 0
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    return label
  }()

  private let starsCountLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.numberOfLines = 1
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    return label
  }()

  private let forkCountLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.numberOfLines = 1
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    return label
  }()

  private let issueCountLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.numberOfLines = 1
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    return label
  }()

  private let stackview: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = NSLayoutConstraint.Axis.vertical
    stackView.distribution = UIStackView.Distribution.fill
    stackView.alignment = UIStackView.Alignment.leading
    stackView.spacing = 20.0
    stackView.contentMode = .scaleAspectFill
    return stackView
  }()

  private let languageStackview: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = NSLayoutConstraint.Axis.horizontal
    stackView.distribution = UIStackView.Distribution.fill
    stackView.alignment = UIStackView.Alignment.leading
    stackView.spacing = 10.0
    stackView.contentMode = .scaleAspectFit
    return stackView
  }()

  private var repositoryData: RepositoryModel?

  // MARK: - Actions

  // MARK: - Public API

  init(frame: CGRect, data: RepositoryModel, languages: NSMutableString) {
    super.init(frame: frame)
    repositoryData = data
    createSubviews(with: data, languages: languages)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: - Private API

  private func createSubviews(with repositoryData: RepositoryModel, languages: NSMutableString) {
    addSubview(view)
    view.addSubview(stackview)
    stackview.addArrangedSubview(repositoryNameLabel)
    stackview.addArrangedSubview(repositoryFullNameLabel)
    stackview.addArrangedSubview(descriptionLabel)
    stackview.addArrangedSubview(languageStackview)
    stackview.addArrangedSubview(starsCountLabel)
    stackview.addArrangedSubview(forkCountLabel)
    stackview.addArrangedSubview(issueCountLabel)
    languageStackview.addArrangedSubview(languagesTitleLabel)
    languageStackview.addArrangedSubview(languagesLabel)
    stackview.clipsToBounds = false
    applyLayout()
    setData(repositoryData, languages)
  }

  private func applyLayout() {
    stackview.snp.makeConstraints { make in
      make.leading.top.trailing.equalTo(view).inset(10)
    }
    view.snp.makeConstraints { make in
      make.leading.top.trailing.bottom.equalToSuperview()
    }
    languagesLabel.setContentCompressionResistancePriority(UILayoutPriority(999), for: .horizontal)
    languagesTitleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
  }

  private func customizeLabel(label: UILabel,
                              baseText: String,
                              text: String,
                              imageName: String,
                              color: UIColor = .black,
                              font: UIFont = UIFont.defaultFont) {
    let imageAttachment = NSTextAttachment()
    imageAttachment.image = UIImage(named: imageName)
    let imageOffsetY: CGFloat = -4.0
    imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image?.size.width ?? 0, height: imageAttachment.image?.size.height ?? 0)
    let attachmentString = NSAttributedString(attachment: imageAttachment)
    let completeText = NSMutableAttributedString(string: "")
    completeText.append(attachmentString)
    let textAfterIcon = NSAttributedString(
      string: " \(baseText)",
      attributes: [
        .foregroundColor: UIColor.black,
        .font: UIFont.defaultBoldFont
      ])
    completeText.append(textAfterIcon)
    let detailTitle = NSAttributedString(
      string: text,
      attributes: [
        .foregroundColor: color,
        .font: font
      ])
    completeText.append(detailTitle)
    label.textAlignment = .center
    label.attributedText = completeText
  }

  private func setupLabel(_ label: UILabel?, baseText: String = "", text: String?, color: UIColor = .black, font: UIFont = UIFont.defaultFont) {
    let baseTitle = NSMutableAttributedString(
      string: baseText,
      attributes: [
        .foregroundColor: UIColor.black,
        .font: UIFont.defaultBoldFont
      ])
    if let text = text, !text.isEmpty {
      let detailTitle = NSAttributedString(
        string: text,
        attributes: [
          .foregroundColor: color,
          .font: font
        ])
      baseTitle.append(detailTitle)
      label?.attributedText = baseTitle
    } else {
      label?.isHidden = true
    }
  }

  private func setData(_ repositoryData: RepositoryModel, _ languages: NSMutableString) {
    setupLabel(repositoryNameLabel, baseText: "Name: ", text: repositoryData.name, color: .repositoryBlue, font: .defaultBoldFont)
    setupLabel(repositoryFullNameLabel, baseText: "Full name: ", text: repositoryData.fullName, color: .repositoryBlue, font: .defaultBoldFont)
    setupLabel(descriptionLabel, baseText: "Description: ", text: repositoryData.description)
    languagesTitleLabel.text = "Language:"
    languagesLabel.text = languages as String
    customizeLabel(label: starsCountLabel,
                   baseText: "Stars: ",
                   text: String(repositoryData.stargazersCount ?? 0),
                   imageName: "star")
    customizeLabel(label: forkCountLabel,
                   baseText: "Forks: ",
                   text: String(repositoryData.forksCount ?? 0),
                   imageName: "fork")
    customizeLabel(label: issueCountLabel,
                   baseText: "Issues: ",
                   text: String(repositoryData.openIssuesCount ?? 0),
                   imageName: "issue")
  }
}
