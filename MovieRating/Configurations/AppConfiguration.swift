//
//  AppConfiguration.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 29/5/18.
//  Copyright © 2018 Hien Tran. All rights reserved.
//

import Foundation

public struct AppConfiguration {
    public let language: Language
    public let locale: Locale
    
    init(
        language: Language = Language(languageStrings: Locale.preferredLanguages) ?? .en,
        locale: Locale = .current)
    {
        self.language = language
        self.locale = locale
    }
}
