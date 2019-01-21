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
                if moveDirection != oldValue.oppositeDirection {
                    moveDirectionQueueElement = moveDirection
                    moveDirection = oldValue
                } else {
                    moveDirectionQueueElement = nil
                }
            } else if moveDirection == oldValue.oppositeDirection {
                moveDirection = oldValue
            } else if moveDirection != oldValue {
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
    var nextHeadPosition: Point {
        return head + moveDirection.point
    }
    
    init() {
        let beginningHead = Point(x: Constants.gameAreaSize/2, y: Constants.gameAreaSize/2)
        for i in (0..<Constants.startingSnakeSize).reversed() {
            body.enqueue(Point(x: beginningHead.x, y: beginningHead.y - i))
        }
    }
    
    func move() {
        let collisionType = game?.checkCollision(nextHeadPosition)
        game?.manageCollision(collisionType)
        if !(collisionType?.shouldStopTheGame ?? false) {
            body.enqueue(nextHeadPosition)
            if (body.count > length) {
                _=body.dequeue()
            }
        }
        canChangeMoveDirection = true
    }
    
    func eat(_ food: Food) {
        length += Constants.snakeGrowth
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
