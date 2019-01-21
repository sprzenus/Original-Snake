//
//  Game.swift
//  Original Snake
//
//  Created by Bartłomiej Świerad on 05/12/2018.
//  Copyright © 2018 Bartłomiej Świerad. All rights reserved.
//

import Foundation

class Game {
    static var main: Game?
    static func generateNewGame(vc: GameViewController?) {
        main = Game(vc: vc)
    }
    
    let snake = Snake()
    var food: Food
    var score: Int = 0 {
        didSet {
            vc?.scoreChanged()
        }
    }
    weak var vc: GameViewController?
    private(set) var isStopped = false
    private(set) var isPaused = true
    private(set) var timer = Timer()
    
    init(vc: GameViewController?) {
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
        if score != 0 {
            UserDefaults.standard.scores.append(Score(timestamp: Int64(Date().timeIntervalSince1970), points: score))
        }
    }
    
    public func manageCollision(_ type: CollisionType?) {
        guard let type = type else {
            return
        }
        if type.shouldStopTheGame {
            stop()
            print("GAME OVER")
        }
        if type == .food {
            snake.eat(food)
            score += 1
            food = Food(position: randomFoodPosition())
        }
    }
    
    public func checkCollision(_ newHead: Point) -> CollisionType? {
        if checkGameAreaEdgeCollision(newHead) {
            return .gameArea
        } else if checkSnakeCollision(newHead) {
            return .snake
        } else if checkFoodCollision(newHead) {
            return .food
        }
        return nil
    }
        
    private func randomFoodPosition() -> Point {
        let allFields = Constants.gameAreaSize * Constants.gameAreaSize
        let emptyFields = allFields - snake.body.count - 1
        var randomNumber = Int.random(in: 0..<emptyFields)
        for i in 0..<allFields {
            let x = i % Constants.gameAreaSize
            let y = i / Constants.gameAreaSize
            let point = Point(x: x, y: y)
            guard !snake.body.contains(where: { $0 == point })
                && food.position != point else { continue }
            if randomNumber == 0 {
                return point
            }
            randomNumber -= 1
        }
        let x = allFields % Constants.gameAreaSize
        let y = allFields / Constants.gameAreaSize
        return Point(x: x, y: y)
    }
    
    private func checkGameAreaEdgeCollision(_ newHead: Point) -> Bool {
        return !(newHead.x > -1 && newHead.x < Constants.gameAreaSize &&
            newHead.y > -1 && newHead.y < Constants.gameAreaSize)
    }
    
    private func checkSnakeCollision(_ newHead: Point) -> Bool {
        for element in snake.body {
            if newHead == element {
                return true
            }
        }
        return false
    }
    
    private func checkFoodCollision(_ newHead: Point) -> Bool {
        return newHead == food.position
    }
    
    enum CollisionType: String, CaseIterable {
        case gameArea, food, snake
        
        var shouldStopTheGame: Bool {
            switch self {
            case .food: return false
            default: return true
            }
        }
    }
}
