//
//  Utility.swift
//  TODO
//
//  Created by Tomotaka Kawai on 2024/07/07.
//

import Foundation

class Utility {
    static let shared = Utility()
    
    private init() {}
    
    func getCurrentDateString() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}
