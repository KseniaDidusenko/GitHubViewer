//
//  SignInView.swift
//  GitHubViewer
//
//  Created by Ksenia on 02.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import SnapKit
import UIKit

class SignInView: UIView {

  // MARK: - Public properties

  var didButtonTapped: ((_ : UIButton) -> Void)?

  // MARK: - Outlets

  // MARK: - Private properties

  private let view: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(hexString: "24292e")
    return view
  }()

  private let signInButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("Sign In GitHub", for: .normal)
    button.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = UIColor(hexString: "28a745")
    button.layer.cornerRadius = 20
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor(hexString: "28a745").cgColor
    return button
  }()

  private let iconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "githubIcon")
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  // MARK: - Actions

  // MARK: - Public API

  override init(frame: CGRect) {
    super.init(frame: frame)
    createSubviews()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    createSubviews()
  }

  func createSubviews() {
    addSubview(view)
    addSubview(signInButton)
    addSubview(iconImageView)
    applyLayout()
    signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
  }

  // MARK: - Private API

  @objc func signInButtonTapped(sender: UIButton) {
      didButtonTapped?(sender)
  }

  func applyLayout() {
    view.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    signInButton.snp.makeConstraints { make in
      make.centerX.centerY.equalToSuperview()
      make.width.equalTo(180)
      make.height.equalTo(40)
      make.top.equalTo(iconImageView.snp.bottom).offset(15)
    }
    iconImageView.snp.makeConstraints { make in
      make.width.height.equalTo(150)
      make.centerX.equalToSuperview()
    }
  }
}
