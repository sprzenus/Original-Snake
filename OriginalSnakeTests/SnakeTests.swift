//
//  SnakeTests.swift
//  OriginalSnakeTests
//
//  Created by Bartłomiej Świerad on 19/01/2019.
//  Copyright © 2019 Bartłomiej Świerad. All rights reserved.
//

import XCTest
@testable import Original_Snake

class SnakeTests: XCTestCase {
    
    func testSnakeSingleMove() {
        // given
        let snake = Snake()
        let targetPosition = snake.head + snake.moveDirection.point
        // when
        snake.move()
        // then
        XCTAssertEqual(snake.head, targetPosition, "Snake position after single move is wrong")
    }
    
    func testSnakeTurnAround() {
        let snake = Snake()
        let targetPosition = snake.head + Snake.Direction.left.point + Snake.Direction.up.point
        
        snake.moveDirection = .left
        snake.moveDirection = .up
        snake.move()
        snake.move()
        
        XCTAssertEqual(snake.head, targetPosition, "Snake position after turn around is wrong")
    }
    
    func testSnakeMistakeRightLeftUpMoveSequence() {
        let snake = Snake()
        let targetPosition = snake.head + Snake.Direction.left.point + Snake.Direction.up.point
        
        snake.moveDirection = .right
        snake.moveDirection = .left
        snake.moveDirection = .up
        snake.move()
        snake.move()
        
        XCTAssertEqual(snake.head, targetPosition, "Snake position after right-left-up misclick is wrong")
    }
    
    func testSnakeMistakeRightUpLeftMoveSequence() {
        let snake = Snake()
        let targetPosition = snake.head + Snake.Direction.left.point + Snake.Direction.left.point
        
        snake.moveDirection = .right
        snake.moveDirection = .up
        snake.moveDirection = .left
        snake.move()
        snake.move()
        
        XCTAssertEqual(snake.head, targetPosition, "Snake position after right-up-left misclick is wrong")
    }
    
    func testSnakeDoubleLeftAndUpMoveSequence() {
        let snake = Snake()
        let targetPosition = snake.head + Snake.Direction.left.point + Snake.Direction.up.point
        
        snake.moveDirection = .left
        snake.moveDirection = .left
        snake.moveDirection = .up
        snake.move()
        snake.move()
        
        XCTAssertEqual(snake.head, targetPosition, "Snake position after left-left-up sequence is wrong")
    }
    
    func testSnakeDownRightUpMoveSequence() {
        let snake = Snake()
        let targetPosition = snake.head + Snake.Direction.right.point + Snake.Direction.up.point
        
        snake.moveDirection = .down
        snake.moveDirection = .right
        snake.moveDirection = .up
        snake.move()
        snake.move()
        
        XCTAssertEqual(snake.head, targetPosition, "Snake position after down-right-up misclick is wrong")
    }
}
