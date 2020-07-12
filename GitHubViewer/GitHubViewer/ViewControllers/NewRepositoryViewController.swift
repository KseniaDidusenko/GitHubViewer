//
//  NewRepositoryViewController.swift
//  GitHubViewer
//
//  Created by Ksenia on 12.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import UIKit

class NewRepositoryViewController: UIViewController {

  // MARK: - Public properties

  weak var coordinatorNewRepository: NewRepositoryCoordinator?
  var owner: String?

  // MARK: - Outlets

  // MARK: - Private properties

  private var licenseArray = [String]()
  private var gitignoreArray = [String]()
  private var textFieldsArray = [UITextField]()
  private var gitignoreTextfield = UITextField()
  private var licenseTextField = UITextField()
  private var repositoryNameTextfield = UITextField()
  private var repositoryDescription = UITextView()
  private var segmentedControl = UISegmentedControl()

  // MARK: - View controller view's lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    hideKeyboardWhenTappedAround()
    setupNavigationBar()
    getGitignoreList()
  }

  // MARK: - Navigation

  // MARK: - Actions

  // MARK: - Public API

  // MARK: - Private API

  private func setupNavigationBar() {
    let cancelButton = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
    self.navigationItem.leftBarButtonItem = cancelButton
  }

  @objc func cancelButtonTapped() {
    navigationController?.popViewController(animated: true)
  }

  private func getGitignoreList() {
    GitHubService().getGitignoreList { result in
      switch result {
      case .success(let data):
        self.gitignoreArray = data
        self.getLicenceList()
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }

  private func getLicenceList() {
    GitHubService().getLicenseList { result in
      switch result {
      case .success(let data):
        for item in data {
          self.licenseArray.append(item.key ?? "")
        }
        self.addCustomView()
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }

  private func addCustomView() {
    let newRepositoryView = NewRepositoryView(frame: view.frame, owner: owner)
    view.addSubview(newRepositoryView)
    newRepositoryView.didButtonTapped = { [weak self] button in
      self?.createButtonTapped(button)
    }
    let gitignorePickerView: UIPickerView = newRepositoryView.getGitignorePickerView()
    gitignorePickerView.delegate = self
    gitignorePickerView.dataSource = self
    let licensePickerView: UIPickerView = newRepositoryView.getLicensePickerView()
    licensePickerView.delegate = self
    licensePickerView.dataSource = self
    gitignoreTextfield = newRepositoryView.getGitignoreTextField()
    gitignoreTextfield.inputView = gitignorePickerView
    licenseTextField = newRepositoryView.getLicenseTextField()
    licenseTextField.inputView = licensePickerView
    repositoryNameTextfield = newRepositoryView.getRepositoryNameTextField()
    repositoryDescription = newRepositoryView.getDescriptionTextView()
    repositoryDescription.delegate = self
    segmentedControl = newRepositoryView.getSegmentedControl()
    createToolbar()
    textFieldsArray = [repositoryNameTextfield, gitignoreTextfield, licenseTextField]
    for item in textFieldsArray {
      item.delegate = self
    }
  }

  private func createToolbar() {
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closePickerView))
    doneButton.tintColor = .black
    toolbar.setItems([doneButton], animated: false)
    toolbar.isUserInteractionEnabled = true
    licenseTextField.inputAccessoryView = toolbar
    gitignoreTextfield.inputAccessoryView = toolbar
  }

  @objc private func closePickerView() {
    view.endEditing(true)
  }

  private func validateFields() -> Bool {
    if repositoryNameTextfield.text?.isEmpty ?? false {
      showAlert(title: "Validation error", message: "Please enter repository name!", buttonTitle: "Ok")
      return false
    }
    return true
  }

  private func createButtonTapped(_ sender: UIButton) {
    if !validateFields() { return }
    sender.isEnabled = false
    var privacy = false
    switch segmentedControl.selectedSegmentIndex {
    case 0:
      privacy = true
    case 1:
      privacy = false
    default:
      print("")
    }
    let newRepository = NewRepositoryModel(name: repositoryNameTextfield.text,
                                           description: repositoryDescription.text,
                                           privacy: privacy,
                                           gitignoreTemplate: gitignoreTextfield.text ?? "",
                                           licenseTemplate: licenseTextField.text ?? "")
    GitHubService().createUser(newRepository) { result in
      sender.isEnabled = true
      switch result {
      case .success(let data):
        print(data)
        let alert = UIAlertController(title: "", message: "Repository successfully created!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel) { _ in
          self.navigationController?.popViewController(animated: true)
        })
        self.present(alert, animated: true, completion: nil )
      case .failure(let error):
        self.showAlert(title: "Error", message: error.localizedDescription)
      }
    }
  }
}

extension NewRepositoryViewController: UIPickerViewDelegate { }

extension NewRepositoryViewController: UIPickerViewDataSource {

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    switch pickerView.tag {
    case 0:
      return gitignoreArray.count
    case 1:
      return licenseArray.count
    default:
      return 0
    }
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    switch pickerView.tag {
    case 0:
      let row = gitignoreArray[row]
      return row
    case 1:
      let row = licenseArray[row]
      return row
    default:
      return ""
    }
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    switch pickerView.tag {
    case 0:
      gitignoreTextfield.text = gitignoreArray[row]
    case 1:
      licenseTextField.text = licenseArray[row]
    default:
      break
    }
  }
}

extension NewRepositoryViewController: UITextViewDelegate {

  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
      gitignoreTextfield.becomeFirstResponder()
      return false
    }
    return true
  }
}

extension NewRepositoryViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let selectedTextFieldIndex = textFieldsArray.firstIndex(of: textField), selectedTextFieldIndex < textFieldsArray.count - 1 {
      if selectedTextFieldIndex == 0 {
        repositoryDescription.becomeFirstResponder()
      } else {
        textFieldsArray[selectedTextFieldIndex + 1].becomeFirstResponder()
      }
    } else {
      textField.resignFirstResponder()
    }
    return true
  }
}
