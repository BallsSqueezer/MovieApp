//
//  AppConfigurationManager.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 29/5/18.
//  Copyright © 2018 Hien Tran. All rights reserved.
//
import Foundation

public struct AppConfigurationManager {
    
    fileprivate static var stack = [AppConfiguration()]
    
    public static var current: AppConfiguration! {
        return stack.last
    }
    
    public static func replaceCurrentConfig(
        language: Language = AppConfigurationManager.current.language,
        locale: Locale = AppConfigurationManager.current.locale)
    {
        let cofig = AppConfiguration(language: language, locale: locale)
        stack.append(cofig)
        stack.remove(at: stack.count - 2)
    }
}
