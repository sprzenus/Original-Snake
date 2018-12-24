//
//  Constants.swift
//  Original Snake
//
//  Created by Bartłomiej Świerad on 04/12/2018.
//  Copyright © 2018 Bartłomiej Świerad. All rights reserved.
//

import UIKit

class Constants {
    static let gameAreaSizeInPoints: CGFloat = 300
    
    static let gameAreaSize: Int = 25
    
    static let startingSnakeSize: Int = 3
    
    static let speedInPointsPerSecond: Double = 7
    
    
    static let snakeGrowth: Int = 3
    
    // MARK: Constants set automatically
    
    static let scale: CGFloat = {
        return CGFloat(gameAreaSizeInPoints) / CGFloat(gameAreaSize)
    }()
    
    static let refreshTimeInterval: TimeInterval = 1 / Constants.speedInPointsPerSecond

}
