//
//  AppConfigurationManager.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 29/5/18.
//  Copyright © 2018 Hien Tran. All rights reserved.
//
import Foundation

public struct AppConfigurationManager {
    
    private static var _current = AppConfiguration()
    
    public static var current: AppConfiguration! {
        return _current
    }
    
    public static func updateCurrentConfig(
        networkSession: NetworkSession = AppConfigurationManager.current.networkSession,
        language: Language = AppConfigurationManager.current.language,
        locale: Locale = AppConfigurationManager.current.locale)
    {
        _current = AppConfiguration(networkSession: networkSession, language: language, locale: locale)
    }
}
