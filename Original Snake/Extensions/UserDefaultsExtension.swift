//
//  UserDefaultsExtension.swift
//  Original Snake
//
//  Created by Bartłomiej Świerad on 22/12/2018.
//  Copyright © 2018 Bartłomiej Świerad. All rights reserved.
//

import Foundation

extension UserDefaults {
    static private let kScores = "scores"
    
    var scores: [Score] {
        get {
            if let data = data(forKey: UserDefaults.kScores) {
                return (try? PropertyListDecoder().decode(Array<Score>.self, from: data)) ?? []
            }
            return []
        }
        set {
            let sortedNewValue = newValue.sorted()
            set(try? PropertyListEncoder().encode(sortedNewValue), forKey: UserDefaults.kScores)
        }
    }
    
}
