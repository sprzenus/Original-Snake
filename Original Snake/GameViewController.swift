//
//  GameViewController.swift
//  Original Snake
//
//  Created by Bartłomiej Świerad on 04/12/2018.
//  Copyright © 2018 Bartłomiej Świerad. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var gameAreaView: UIView!
    @IBOutlet var gameAreaSizeConstraint: NSLayoutConstraint!
    
    lazy var game: Game = {
        return Game(vc: self)
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get { return .lightContent }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gameAreaSizeConstraint.constant = Constants.gameAreaSizeInPoints
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }
    
    @objc func viewTapped(_ touch: UITapGestureRecognizer) {
        if game.isPaused {
            game.resume()
        } else if game.isStopped {
            startNewGame()
        } else {
            let touchPoint = touch.location(in: view)
//            let factor = view.frame.width / view.frame.height
//            let first = touchPoint.x - touchPoint.y * factor // \
//            let second = touchPoint.x - (view.frame.height - touchPoint.y) * factor // /
            
            if game.snake.moveDirection == .left || game.snake.moveDirection == .right {
                if touchPoint.y < view.frame.height / 2 {
                    game.snake.moveDirection = .up
                } else {
                    game.snake.moveDirection = .down
                }
            } else {
                if touchPoint.x < view.frame.width / 2 {
                    game.snake.moveDirection = .left
                } else {
                    game.snake.moveDirection = .right
                }
            }
//            if game.snake.moveDirection != .right && first < 0 && second < 0 {
//                game.snake.moveDirection = .left
//            } else if game.snake.moveDirection != .down && first > 0 && second < 0 {
//                game.snake.moveDirection = .up
//            } else if game.snake.moveDirection != .left && first > 0 && second > 0 {
//                game.snake.moveDirection = .right
//            } else if game.snake.moveDirection != .up && first < 0 && second > 0 {
//                game.snake.moveDirection = .down
//            }
        }
    }
    
    public func refresh() {
        draw()
    }
    
    private func draw() {
        var tempObjects = gameAreaView.subviews
        for snakePosition in game.snake.body {
            if let object = tempObjects.popLast() as? ObjectView {
                reuseObject(object, at: snakePosition)
            } else {
                createObject(at: snakePosition)
            }
        }
        if let object = tempObjects.popLast() as? ObjectView {
            reuseObject(object, at: game.food.position)
        } else {
            createObject(at: game.food.position)
        }
        if !tempObjects.isEmpty {
            tempObjects.forEach { $0.removeFromSuperview() }
        }
    }
    
    private func reuseObject(_ object: ObjectView, at point: Point) {
        object.place(at: point)
    }
    
    private func createObject(at point: Point) {
        let object = ObjectView()
        object.place(at: point)
        gameAreaView.addSubview(object)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func startNewGame() {
        game = Game(vc: self)
        refresh()
    }
    
    
}
