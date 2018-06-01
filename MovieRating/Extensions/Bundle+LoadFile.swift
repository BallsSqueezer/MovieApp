//
//  Bundle+LoadFile.swift
//  MovieRating
//
//  Created by Hien Quang Tran on 23/5/18.
//  Copyright © 2018 Hien Tran. All rights reserved.
//

import Foundation

extension Bundle {
    public static func loadJSONFile(name: String, inBundle bundle: Bundle = targetBundle) -> JSON? {
        guard
            let fileURL = bundle.url(forResource: name, withExtension: "json"),
            let data =  try? Data(contentsOf: fileURL),
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSON
            else { return nil }
        
        return json
    }
}
