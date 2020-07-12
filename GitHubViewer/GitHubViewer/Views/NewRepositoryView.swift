//
//  NewRepositoryView.swift
//  GitHubViewer
//
//  Created by Ksenia on 12.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import UIKit

class NewRepositoryView: UIView {

  // MARK: - Public properties

  var didButtonTapped: ((_ : UIButton) -> Void)?

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
    label.font = UIFont.defaultBoldFont
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.textAlignment = .left
    label.numberOfLines = 0
    label.adjustsFontSizeToFitWidth = true
    return label
  }()

  private let ownerTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.defaultBoldFont
    label.textAlignment = .left
    label.numberOfLines = 1
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    return label
  }()

  private let repositoryNameTextField: UITextField = {
    let textField = UITextField()
    textField.textColor = .black
    textField.font = UIFont.defaultFont
    textField.textAlignment = .left
    textField.placeholder = "Repository Name"
    textField.borderStyle = .roundedRect
    return textField
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

  private let repositoryNameStackview: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = NSLayoutConstraint.Axis.horizontal
    stackView.distribution = UIStackView.Distribution.fill
    stackView.alignment = UIStackView.Alignment.center
    stackView.spacing = 10.0
    stackView.contentMode = .scaleAspectFit
    return stackView
  }()

  private let descriptionTextView: UITextView = {
    let textView = UITextView()
    textView.textColor = .black
    textView.font = UIFont.defaultFont
    textView.textAlignment = .left
    textView.layer.borderColor = UIColor.repositoryLightGray.cgColor
    textView.layer.borderWidth = 1
    textView.layer.cornerRadius = 10
    textView.isSelectable = true
    textView.isEditable = true
    return textView
  }()

  private let segmentedControl: UISegmentedControl = {
    let sc = UISegmentedControl(items: ["Private", "Public"])
    sc.selectedSegmentTintColor = UIColor.white
    sc.selectedSegmentIndex = 1
    return sc
  }()

  private let gitignorePickerView: UIPickerView = {
    let pickerView = UIPickerView()
    pickerView.tag = 0
    pickerView.backgroundColor = .white
    return pickerView
  }()

  private let licensePickerView: UIPickerView = {
    let pickerView = UIPickerView()
    pickerView.tag = 1
    pickerView.backgroundColor = .white
    return pickerView
  }()

  private let gitignoreTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.defaultBoldFont
    label.textAlignment = .left
    label.numberOfLines = 1
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    label.text = "Add .gitignore:"
    return label
  }()

  private let gitignoreTextField: UITextField = {
    let textField = UITextField()
    textField.textColor = .black
    textField.font = UIFont.defaultFont
    textField.textAlignment = .left
    textField.placeholder = "None"
    textField.borderStyle = .roundedRect
    return textField
  }()

  private let gitignoreStackview: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = NSLayoutConstraint.Axis.horizontal
    stackView.distribution = UIStackView.Distribution.fill
    stackView.alignment = UIStackView.Alignment.center
    stackView.spacing = 10.0
    stackView.contentMode = .scaleAspectFit
    return stackView
  }()

  private let licenseTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont.defaultBoldFont
    label.textAlignment = .left
    label.numberOfLines = 1
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    label.text = "Add license:"
    return label
  }()

  private let licenseTextField: UITextField = {
    let textField = UITextField()
    textField.textColor = .black
    textField.font = UIFont.defaultFont
    textField.textAlignment = .left
    textField.placeholder = "None"
    textField.borderStyle = .roundedRect
    textField.isUserInteractionEnabled = true
    return textField
  }()

  private let licenseStackview: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = NSLayoutConstraint.Axis.horizontal
    stackView.distribution = UIStackView.Distribution.fill
    stackView.alignment = UIStackView.Alignment.center
    stackView.spacing = 10.0
    stackView.contentMode = .scaleAspectFit
    return stackView
  }()

  private let createButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Create Repository", for: .normal)
    button.titleLabel?.font = UIFont.defaultBoldFont
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .repositoryGreen
    button.layer.cornerRadius = 20
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.repositoryGreen.cgColor
    return button
  }()

  private var repoOwner = String()

  // MARK: - Actions

  // MARK: - Public API

  init(frame: CGRect, owner: String?) {
    super.init(frame: frame)
    repoOwner = owner ?? ""
    createSubviews()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    createSubviews()
  }

  func getGitignoreTextField() -> UITextField {
    return gitignoreTextField
  }

  func getLicenseTextField() -> UITextField {
    return licenseTextField
  }

  func getRepositoryNameTextField() -> UITextField {
    return repositoryNameTextField
  }

  func getDescriptionTextView() -> UITextView {
    return descriptionTextView
  }

  func getSegmentedControl() -> UISegmentedControl {
    return segmentedControl
  }

  func getGitignorePickerView() -> UIPickerView {
    return gitignorePickerView
  }

  func getLicensePickerView() -> UIPickerView {
    return licensePickerView
  }

  // MARK: - Private API

  private func createSubviews() {
    addSubview(stackview)
    addSubview(createButton)
    stackview.addArrangedSubview(ownerTitleLabel)
    stackview.addArrangedSubview(repositoryNameStackview)
    stackview.addArrangedSubview(descriptionLabel)
    stackview.addArrangedSubview(descriptionTextView)
    stackview.addArrangedSubview(segmentedControl)
    stackview.addArrangedSubview(gitignoreStackview)
    stackview.addArrangedSubview(licenseStackview)
    repositoryNameStackview.addArrangedSubview(repositoryNameLabel)
    repositoryNameStackview.addArrangedSubview(repositoryNameTextField)
    gitignoreStackview.addArrangedSubview(gitignoreTitleLabel)
    gitignoreStackview.addArrangedSubview(gitignoreTextField)
    licenseStackview.addArrangedSubview(licenseTitleLabel)
    licenseStackview.addArrangedSubview(licenseTextField)
    stackview.clipsToBounds = false
    applyLayout()
    setData()
    createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
  }

  @objc func createButtonTapped(sender: UIButton) {
    didButtonTapped?(sender)
  }

  private func applyLayout() {
    stackview.snp.makeConstraints { make in
      make.leading.top.trailing.equalToSuperview().inset(10)
    }
    segmentedControl.snp.makeConstraints { make in
      make.trailing.leading.equalTo(stackview).inset(10)
    }
    descriptionTextView.snp.makeConstraints { make in
      make.height.equalTo(80)
      make.trailing.leading.equalTo(stackview).inset(10)
    }
    repositoryNameTextField.snp.makeConstraints { make in
      make.trailing.equalTo(stackview).inset(10)
    }
    gitignoreTextField.snp.makeConstraints { make in
      make.trailing.equalTo(stackview).inset(10)
    }
    licenseTextField.snp.makeConstraints { make in
      make.trailing.equalTo(stackview).inset(10)
    }
    createButton.snp.makeConstraints { make in
      make.top.equalTo(stackview.snp.bottom).offset(50)
      make.centerX.equalToSuperview()
      make.width.equalTo(160)
      make.height.equalTo(40)
    }
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

  private func setData() {
    repositoryNameLabel.text = "Repository Name:"
    setupLabel(ownerTitleLabel, baseText: "Owner: ", text: repoOwner, color: .black, font: .defaultFont)
    setupLabel(descriptionLabel, baseText: "Description: ", text: "(optional)", color: .repositoryLightGray, font: .defaultSmallFont)
  }
}
