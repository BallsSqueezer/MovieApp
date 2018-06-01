//
//  WalkthroughViewModel.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 24/5/18.
//  Copyright © 2018 Hien Tran. All rights reserved.
//
import Foundation

public struct WalkthroughViewModel {
    private let walkthroughContents = [
        WalkthroughContent(heading: LocalizedStrings.walkthroughPersonalizeTitle(),
                           imageFile: "walkthru1",
                           content: LocalizedStrings.walkthroughPersonalizeContent()),
        WalkthroughContent(heading: LocalizedStrings.walkthroughDiscoverTitle(),
                           imageFile: "walkthru4",
                           content: LocalizedStrings.walkthroughDiscoverContent()),
        WalkthroughContent(heading: LocalizedStrings.walkthroughEnjoyableTitle(),
                           imageFile: "walkthru5",
                           content: LocalizedStrings.walkthroughDiscoverContent())
    ]
    
    private var _currentIndex = 0
    
    var currentIndex: Int {
        return _currentIndex
    }
    
    var numberOfItems: Int {
        return walkthroughContents.count
    }
    
    var isInLastIndex: Bool {
        return currentIndex == numberOfItems - 1
    }
    
    public init() {}
    
    func content(at index: Int) -> WalkthroughContent {
        return walkthroughContents[index]
    }
    
    mutating func setCurrentIndex(to index: Int) {
        self._currentIndex = index
    }
}
