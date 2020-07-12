//
//  Typealias+Extension.swift
//  GitHubViewer
//
//  Created by Ksenia on 06.07.2020.
//  Copyright © 2020 Ksenia. All rights reserved.
//

import Foundation

typealias TokenResultClosure = (Result<TokenModel>) -> Void
typealias UserResultClosure = (Result<UserModel>) -> Void
typealias RepositoryResultClosure = (Result<[RepositoryModel]>) -> Void
typealias NewRepositoryResultClosure = (Result<RepositoryModel>) -> Void
typealias EmptyClosure = () -> Void
typealias EmptyResultClosure = (Result<Void>) -> Void
typealias LanguagesResultClosure = (Result<LanguageModel>) -> Void
typealias GitIgnoreResultClosure = (Result<[String]>) -> Void
typealias LicenseResultClosure = (Result<[LicenseModel]>) -> Void
