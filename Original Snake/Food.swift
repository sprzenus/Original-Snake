//
//  Food.swift
//  Original Snake
//
//  Created by Bartłomiej Świerad on 05/12/2018.
//  Copyright © 2018 Bartłomiej Świerad. All rights reserved.
//

import Foundation

class Food {
    var position: Point = Point(x: 0, y: 0)
    
    init(position: Point) {
        self.position = position
    }
    init () {}
}
