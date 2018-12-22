//
//  Point.swift
//  Original Snake
//
//  Created by Bartłomiej Świerad on 04/12/2018.
//  Copyright © 2018 Bartłomiej Świerad. All rights reserved.
//

import Foundation

struct Point {
    var x: Int
    var y: Int
}

func -(left: Point, right: Point) -> Point {
    return Point(x: left.x - right.x,
                 y: left.y - right.y)
}

func +(left: Point, right: Point) -> Point {
    return Point(x: left.x + right.x,
                 y: left.y + right.y)
}

func ==(left: Point, right: Point) -> Bool {
    return left.x == right.x && left.y == right.y
}

func !=(left: Point, right: Point) -> Bool {
    return left.x != right.x || left.y != right.y
}
