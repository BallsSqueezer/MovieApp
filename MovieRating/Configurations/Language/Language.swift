//
//  Language.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 29/5/18.
//  Copyright © 2018 Hien Tran. All rights reserved.
//

public enum Language: String {
    case de
    case en
    case es
    case fr
    case ja
    case vi
    case be
    
    public init?(_ language: String) {
        switch language.lowercased() {
        case "en": self = .en
        case "de": self = .de
        case "es": self = .es
        case "fr": self = .fr
        case "ja": self = .ja
        case "vi": self = .vi
        case "be": self = .be
        default:   return nil
        }
    }
    
    public init?(languageStrings languages: [String]) {
        guard let language = languages
            .lazy
            .map({ String($0.prefix(2)) })
            .flatMap({ Language($0) })
            .first
        else { return nil }
        
        self = language
    }
}
