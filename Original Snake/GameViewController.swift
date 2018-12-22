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
            let touchLocation = touch.location(in: view)
            let directionToMove = getDirectionToMove(touchLocation)
            game.snake.moveDirection = directionToMove
        }
    }
    
    private func getDirectionToMove(_ touchLocation: CGPoint) -> Snake.Direction {
        let factor = view.frame.width / view.frame.height / 2
        let touchY = touchLocation.y - view.bounds.height
        let touchX = touchLocation.x
        let first = touchX - touchY * factor // \
        let second = touchX - (view.frame.height - touchY) * factor // /
        
        if first < 0 && second < 0 {
            return .left
        } else if first > 0 && second < 0 {
            return .up
        } else if first > 0 && second > 0 {
            return .right
        } else {
            return .down
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
    
    private func getLocationByPoint(_ point: Point) -> CGPoint {
        let pointInArea = CGPoint(x: CGFloat(point.x) * Constants.scale, y: CGFloat(point.y) * Constants.scale)
        let pointOnScreen = view.convert(pointInArea, from: gameAreaView)
        return pointOnScreen
    }
}
