//
//  UserInfoView.swift
//  GitHubViewer
//
//  Created by Ksenia on 07.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import UIKit
import SnapKit
import AlamofireImage

class UserInfoView: UIView {

  // MARK: - Public properties

  // MARK: - Outlets

  // MARK: - Private properties

  private let separatorView : UIView = {
    let view = UIView(frame: .zero)
    view.backgroundColor = .gray
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let profileNameLabel : UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
    label.textAlignment = .left
    label.numberOfLines = 0
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    return label
  }()

  private let profileLoginLabel : UILabel = {
    let label = UILabel()
    label.textColor = .gray
    label.font = UIFont(name: "HelveticaNeue", size: 18)
    label.textAlignment = .left
    label.numberOfLines = 0
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.5
    return label
  }()

    private let bioLabel : UILabel = {
      let label = UILabel()
      label.textColor = .black
  //    label.font = UIFont(name: "HelveticaNeue-Light", size: 12)
      label.font = UIFont(name: "HelveticaNeue", size: 16)
      label.textAlignment = .left
      label.numberOfLines = 0
      label.adjustsFontSizeToFitWidth = true
      label.minimumScaleFactor = 0.5
      return label
    }()

    private let emailLabel : UILabel = {
      let label = UILabel()
      label.textColor = .black
  //    label.font = UIFont(name: "HelveticaNeue-Light", size: 12)
      label.font = UIFont(name: "HelveticaNeue", size: 14)
      label.textAlignment = .left
      label.numberOfLines = 0
      label.adjustsFontSizeToFitWidth = true
      label.minimumScaleFactor = 0.5
      return label
    }()

  private var profileImageView : UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.layer.borderWidth = 1.0
    imageView.layer.masksToBounds = false
    imageView.layer.borderColor = UIColor.lightGray.cgColor
    imageView.layer.cornerRadius = 75
    imageView.clipsToBounds = true
    return imageView
  }()

  private let stackview: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = NSLayoutConstraint.Axis.vertical
    stackView.distribution = UIStackView.Distribution.fillEqually
    stackView.alignment = UIStackView.Alignment.leading
    stackView.spacing = 10.0
    stackView.contentMode = .scaleAspectFill
    return stackView
  }()

  var userData: UserModel?
  // MARK: - Actions

  // MARK: - Public API

  init(frame: CGRect, data: UserModel) {
    super.init(frame: frame)
    userData = data
    createSubviews(with: data)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    if let userData = userData {
    createSubviews(with: userData)
    }
  }

  // MARK: - Private API

  private func createSubviews(with userData: UserModel) {
    addSubview(profileImageView)
    addSubview(profileNameLabel)
    addSubview(profileLoginLabel)
    addSubview(bioLabel)
    addSubview(emailLabel)
    addSubview(stackview)
    addSubview(separatorView)
    stackview.addArrangedSubview(profileNameLabel)
    stackview.addArrangedSubview(profileLoginLabel)
    stackview.addArrangedSubview(bioLabel)
    stackview.addArrangedSubview(emailLabel)
    stackview.clipsToBounds = false
    applyLayout()
    setData(userData)
  }

  private func applyLayout() {
    profileImageView.snp.makeConstraints { make in
      make.top.leading.equalToSuperview().offset(15)
      make.height.width.equalTo(150)
    }
    stackview.snp.makeConstraints { make in
      make.leading.equalTo(profileImageView.snp.trailing).offset(10)
      make.top.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().inset(10)
    }
    separatorView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(1)
      make.top.equalTo(profileImageView.snp.bottom).offset(13)
    }
  }

  private func customizeEmailLabel(with email: String) {
    let imageAttachment = NSTextAttachment()
    imageAttachment.image = UIImage(named:"mail")
    let imageOffsetY: CGFloat = -4.0
    imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image?.size.width ?? 0, height: imageAttachment.image?.size.height ?? 0)
    let attachmentString = NSAttributedString(attachment: imageAttachment)
    let completeText = NSMutableAttributedString(string: "")
    completeText.append(attachmentString)
    let textAfterIcon = NSAttributedString(string: " \(email)")
    completeText.append(textAfterIcon)
    emailLabel.textAlignment = .center
    emailLabel.attributedText = completeText
  }

  private func setData(_ userData: UserModel) {
    profileNameLabel.text = userData.name
    profileLoginLabel.text = userData.login
    bioLabel.text = userData.bio
    customizeEmailLabel(with: userData.email ?? "")
    if let imageUrl = URL(string: userData.avatarUrl ?? "") {
        profileImageView.af.setImage(withURL: imageUrl, cacheKey: "CacheUserImageKey\(userData.id)")
    }
  }
}

