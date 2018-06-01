//
//  LocalizedStringsHelpers.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 31/5/18.
//  Copyright © 2018 Hien Tran. All rights reserved.
//

import Foundation

/// Use this class as a look up destination for Bundle. Eg: `let bundle = Bundle(for: BundleClass.self)`.
public class BundleClass {}

public let targetBundle = Bundle(for: BundleClass.self)

public func localizedString(key: String,
                            configuration: AppConfiguration = AppConfigurationManager.current,
                            bundle: Bundle = targetBundle)
                            -> String
{
    let lprojName = lprojFileName(forLanguage: configuration.language)
    
    return bundle.path(forResource: lprojName, ofType: "lproj")
        .flatMap { Bundle(path: $0) }
        .flatMap { $0.localizedString(forKey: key, value: nil, table: nil) }
        .coalesceWith("")
}

private func lprojFileName(forLanguage language: Language) -> String {
    return language.rawValue == "en"
        ? "Base"
        : language.rawValue
}




