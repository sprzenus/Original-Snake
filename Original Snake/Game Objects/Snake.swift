//
//  Snake.swift
//  Original Snake
//
//  Created by Bartłomiej Świerad on 04/12/2018.
//  Copyright © 2018 Bartłomiej Świerad. All rights reserved.
//

import Foundation

class Snake {
    weak var game: Game?
    var moveDirection: Direction = .down {
        didSet {
            if !canChangeMoveDirection {
                moveDirectionQueueElement = moveDirection
                moveDirection = oldValue
            } else if moveDirection == oldValue.oppositeDirection {
                moveDirection = oldValue
            } else {
                canChangeMoveDirection = false
            }
        }
    }
    private var moveDirectionQueueElement: Direction?
    var length: Int = Constants.startingSnakeSize
    private(set) var canChangeMoveDirection = true {
        didSet {
            if canChangeMoveDirection, let newDirection = moveDirectionQueueElement {
                moveDirectionQueueElement = nil
                moveDirection = newDirection
            }
        }
    }
    private(set) var body: Queue<Point> = Queue()
    var head: Point {
        get { return body.end! }
    }
    
    init() {
        let beginningHead = Point(x: Constants.gameAreaSize/2, y: Constants.gameAreaSize/2)
        for i in (0..<Constants.startingSnakeSize).reversed() {
            body.enqueue(Point(x: beginningHead.x, y: beginningHead.y - i))
        }
    }
    
    func move() {
        let newPoint = Point(x: head.x + moveDirection.point.x, y: head.y + moveDirection.point.y)
        game?.checkCollision(newPoint)
        body.enqueue(newPoint)
        if (body.count > length) {
            _=body.dequeue()
        }
        canChangeMoveDirection = true
    }
    
    func eat(_ food: Food) {
        length += 3
    }
    
    enum Direction {
        case up, down, left, right
        
        var point: Point {
            switch self {
            case .up: return Point(x: 0, y: -1)
            case .down: return Point(x: 0, y: 1)
            case .left: return Point(x: -1, y: 0)
            case .right: return Point(x: 1, y: 0)
            }
        }
        
        var oppositeDirection: Direction {
            switch self {
            case .up: return .down
            case .down: return .up
            case .left: return .right
            case .right: return .left
            }
        }
    }
    
}
