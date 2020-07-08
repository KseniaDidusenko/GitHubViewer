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

  private let view : UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(hexString: "24292e")
    return view
  }()

  private let profileNameLabel : UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
    label.textAlignment = .left
    label.numberOfLines = 0
    return label
  }()

  private let profileLoginLabel : UILabel = {
    let label = UILabel()
    label.textColor = .gray
//    label.font = UIFont(name: "HelveticaNeue-Light", size: 12)
    label.font = UIFont(name: "HelveticaNeue", size: 18)
    label.textAlignment = .left
    label.numberOfLines = 0
    return label
  }()

    private let bioLabel : UILabel = {
      let label = UILabel()
      label.textColor = .black
  //    label.font = UIFont(name: "HelveticaNeue-Light", size: 12)
      label.font = UIFont(name: "HelveticaNeue", size: 16)
      label.textAlignment = .left
      label.numberOfLines = 0
      return label
    }()

  private var profileImageView : UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.layer.borderWidth = 1.0
    imageView.layer.masksToBounds = false
    imageView.layer.borderColor = UIColor.lightGray.cgColor
    imageView.layer.cornerRadius = 20
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

  // MARK: - Actions

  // MARK: - Public API

  init(frame: CGRect, data: UserModel) {
    super.init(frame: frame)
    createSubviews(with: data)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
//    createSubviews()
  }

  // MARK: - Private API

  private func createSubviews(with userData: UserModel) {
    addSubview(profileImageView)
    addSubview(profileNameLabel)
    addSubview(profileLoginLabel)
    addSubview(bioLabel)
    addSubview(stackview)
    stackview.addArrangedSubview(profileNameLabel)
    stackview.addArrangedSubview(profileLoginLabel)
    stackview.addArrangedSubview(bioLabel)
    applyLayout()
    setData(userData)
  }

  private func applyLayout() {
//    profileNameLabel.snp.makeConstraints { make in
//      make.top.equalToSuperview().offset(20)
//      make.leading.equalTo(profileImageView.snp.trailing).offset(25)
//    }
    profileImageView.snp.makeConstraints { make in
      make.top.leading.equalToSuperview().offset(15)
      make.height.width.equalTo(150)
    }
    stackview.snp.makeConstraints { make in
      make.leading.equalTo(profileImageView.snp.trailing).offset(25)
      make.top.equalToSuperview().offset(20)
//      make.height.equalTo(30)
    }
  }

  private func setData(_ userData: UserModel) {
    profileNameLabel.text = userData.name
    profileLoginLabel.text = userData.login
    bioLabel.text = userData.bio
    if let imageUrl = URL(string: userData.avatarUrl ?? "") {
        profileImageView.af.setImage(withURL: imageUrl, cacheKey: "CacheUserImageKey\(userData.id)")
    }
  }
}

