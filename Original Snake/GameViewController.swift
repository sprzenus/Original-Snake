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
    
    @IBOutlet var scoreLabel: UILabel!
    
    var snakeObjects: [SnakeObjectView] = []
    var foodObjects: [FoodObjectView] = []
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }
    
    func scoreChanged() {
        scoreLabel.text = String(describing: game.score)
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
        let steeringViewRect = CGRect(x: view.frame.minX,
                                      y: view.frame.maxY / 2,
                                      width: view.frame.width,
                                      height: view.frame.height / 2)
        
        let factor = steeringViewRect.width / steeringViewRect.height
        let touchY = touchLocation.y - steeringViewRect.minY
        let touchX = touchLocation.x - steeringViewRect.minX
        let first = touchX - touchY * factor // \
        let second = touchX - (steeringViewRect.height - touchY) * factor // /
        
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
        var oldSnakeObjects = snakeObjects
        var oldFoodObjects = foodObjects
        snakeObjects.removeAll()
        foodObjects.removeAll()
        for snakePosition in game.snake.body {
            if let object = oldSnakeObjects.popLast() {
                reuseObject(object, at: snakePosition)
            } else {
                createSnakeObject(at: snakePosition)
            }
        }
        if let object = oldFoodObjects.popLast() {
            reuseObject(object, at: game.food.position)
        } else {
            createFoodObject(at: game.food.position)
        }
        if !oldSnakeObjects.isEmpty {
            oldSnakeObjects.forEach { $0.removeFromSuperview() }
        }
        if !oldFoodObjects.isEmpty {
            oldFoodObjects.forEach { $0.removeFromSuperview() }
        }
    }
    
    private func reuseObject(_ object: ObjectView, at point: Point) {
        object.place(at: point)
        if let snakeObject = object as? SnakeObjectView {
            snakeObjects.append(snakeObject)
        } else if let foodObject  = object as? FoodObjectView {
            foodObjects.append(foodObject)
        }
    }
    
    private func createFoodObject(at point: Point) {
        let object = FoodObjectView()
        object.place(at: point)
        foodObjects.append(object)
        gameAreaView.addSubview(object)
    }
    
    private func createSnakeObject(at point: Point) {
        let object = SnakeObjectView()
        object.place(at: point)
        snakeObjects.append(object)
        gameAreaView.addSubview(object)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func startNewGame() {
        game = Game(vc: self)
        scoreChanged()
        refresh()
    }
    
    private func getLocationByPoint(_ point: Point) -> CGPoint {
        let pointInArea = CGPoint(x: CGFloat(point.x) * Constants.scale, y: CGFloat(point.y) * Constants.scale)
        let pointOnScreen = view.convert(pointInArea, from: gameAreaView)
        return pointOnScreen
    }
    
}
