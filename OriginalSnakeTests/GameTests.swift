//
//  GameTests.swift
//  OriginalSnakeTests
//
//  Created by Bartłomiej Świerad on 21/01/2019.
//  Copyright © 2019 Bartłomiej Świerad. All rights reserved.
//

import XCTest
@testable import Original_Snake

class GameTests: XCTestCase {
    let game = Game(vc: nil)
    
    func testCheckCollisionTopEdge() {
        let pointOut = Point(x: 0, y: -1)
        let pointIn = Point(x: 0, y: 0)
        
        XCTAssertEqual(game.checkCollision(pointOut), .gameArea, "No collision after reaching edge of game area")
        XCTAssertNotEqual(game.checkCollision(pointIn), .gameArea, "Collision before reaching edge of game area")
    }
    
    func testCheckCollisionLeftEdge() {
        let pointOut = Point(x: -1, y: 0)
        let pointIn = Point(x: 0, y: 0)
        
        XCTAssertEqual(game.checkCollision(pointOut), .gameArea , "No collision after reaching edge of game area")
        XCTAssertNotEqual(game.checkCollision(pointIn), .gameArea, "Collision before reaching edge of game area")
    }
    
    func testCheckCollisionRightEdge() {
        let pointOut = Point(x: Constants.gameAreaSize, y: 0)
        let pointIn = Point(x: Constants.gameAreaSize - 1, y: 0)
        
        XCTAssertEqual(game.checkCollision(pointOut), .gameArea , "No collision after reaching edge of game area")
        XCTAssertNotEqual(game.checkCollision(pointIn), .gameArea, "Collision before reaching edge of game area")
    }
    
    func testCheckCollisionBottomEdge() {
        let pointOut = Point(x: 0, y: Constants.gameAreaSize)
        let pointIn = Point(x: 0, y: Constants.gameAreaSize - 1)
        
        XCTAssertEqual(game.checkCollision(pointOut), .gameArea , "No collision after reaching edge of game area")
        XCTAssertNotEqual(game.checkCollision(pointIn), .gameArea, "Collision before reaching edge of game area")
    }
}
