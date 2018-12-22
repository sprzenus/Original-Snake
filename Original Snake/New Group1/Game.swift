//
//  Game.swift
//  Original Snake
//
//  Created by Bartłomiej Świerad on 05/12/2018.
//  Copyright © 2018 Bartłomiej Świerad. All rights reserved.
//

import Foundation

class Game {
    let snake = Snake()
    var food: Food
    weak var vc: GameViewController?
    private(set) var isStopped = false
    private(set) var isPaused = true
    private(set) var timer = Timer()
    
    init(vc: GameViewController) {
        self.vc = vc
        food = Food()
        food.position = randomFoodPosition()
        snake.game = self
    }
    
    func resume() {
        guard !isStopped else { return }
        isPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: Constants.refreshTimeInterval, repeats: true, block: { (_) in
            self.snake.move()
            self.vc?.refresh()
        })
    }
    
    func pause() {
        isPaused = true
        timer.invalidate()
    }
    
    func stop() {
        isStopped = true
        timer.invalidate()
    }
    
    public func checkCollision(_ newHead: Point) {
        guard newHead.x > -1 && newHead.x < Constants.gameAreaSize &&
            newHead.y > -1 && newHead.y < Constants.gameAreaSize else {
                stop()
                print("GAME OVER");
                return
        }
        for element in snake.body {
            if newHead == element {
                stop()
                print("GAME OVER")
                return
            }
        }
        if snake.head == food.position {
            snake.eat(food)
            food = Food(position: randomFoodPosition())
            return
        }
    }
        
    private func randomFoodPosition() -> Point {
        let emptyFields = Constants.gameAreaSize * Constants.gameAreaSize - snake.length
        var randomNumber = Int.random(in: 0..<emptyFields)
        for i in 0..<emptyFields {
            let x = i % Constants.gameAreaSize
            let y = i / Constants.gameAreaSize
            if randomNumber == 0 {
                return Point(x: x, y: y)
            }
            if snake.body.contains(where: { $0 == Point(x: x, y: y) }) {
                continue
            }
            randomNumber -= 1
        }
        let x = (emptyFields-1) % Constants.gameAreaSize
        let y = (emptyFields-1) / Constants.gameAreaSize
        return Point(x: x, y: y)
    }
}
