//
//  Constants.swift
//  Original Snake
//
//  Created by Bartłomiej Świerad on 04/12/2018.
//  Copyright © 2018 Bartłomiej Świerad. All rights reserved.
//

import UIKit

class Constants {
    static let scale: CGFloat = 10
    
    static let gameAreaSizeInPoints: CGFloat = 300
    
    static let gameAreaSize: Int = {
        let size = gameAreaSizeInPoints / scale
        guard size == size.rounded() else { fatalError("Size of game area cannot be integer") }
        return Int(size)
    }()
    
    static let startingSnakeSize: Int = 3
    
    static let refreshTimeInterval: TimeInterval = 0.25
}
