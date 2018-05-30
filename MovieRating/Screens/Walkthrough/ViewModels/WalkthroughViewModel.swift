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
        WalkthroughContent(heading: NSLocalizedString("Walkthrough_personalize_title", comment: ""),
                           imageFile: "walkthru1",
                           content: NSLocalizedString("Walkthrough_personalize_content", comment: "")),
        WalkthroughContent(heading: NSLocalizedString("Walkthrough_discover_title", comment: ""),
                           imageFile: "walkthru4",
                           content: NSLocalizedString("Walkthrough_discover_content", comment: "")),
        WalkthroughContent(heading: NSLocalizedString("Walkthrough_enjoyable_title", comment: ""),
                           imageFile: "walkthru5",
                           content: NSLocalizedString("Walkthrough_enjoyable_content", comment: ""))
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
