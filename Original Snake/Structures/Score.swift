//
//  Score.swift
//  Original Snake
//
//  Created by Bartłomiej Świerad on 22/12/2018.
//  Copyright © 2018 Bartłomiej Świerad. All rights reserved.
//

import Foundation

struct Score: Comparable, Equatable, Codable {
    var timestamp: Int64
    var points: Int
    
    init(dictionary dict: [String:Any]) {
        guard let timestamp = dict["timestamp"] as? Int64,
            let points = dict["points"] as? Int else { fatalError("Bad dictionary: \(dict)") }
        self.init(timestamp: timestamp, points: points)
    }
    
    init(timestamp: Int64, points: Int) {
        self.timestamp = timestamp
        self.points = points
    }
    
    func toDictionary() -> [String:Any] {
        return ["timestamp": timestamp,
                "points": points]
    }
    
    static func < (lhs: Score, rhs: Score) -> Bool {
        return lhs.points < rhs.points
    }
    
    static func == (lhs: Score, rhs: Score) -> Bool {
        return lhs.points == rhs.points
    }
}
