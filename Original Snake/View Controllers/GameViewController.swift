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
    
    
    @IBOutlet var scoreStackView: UIStackView!
    @IBOutlet var scoreTitleLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var scoreCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet var highScoreStackView: UIStackView!
    @IBOutlet var highScoreTitleLabel: UILabel!
    @IBOutlet var highScoreLabel: UILabel!
    @IBOutlet var highScoreCenterXConstraint: NSLayoutConstraint!
    
    var snakeObjects: [SnakeObjectView] = []
    var foodObjects: [FoodObjectView] = []
    var collisionObject: CollisionObjectView?
    
    var game: Game {
        if Game.main?.vc == nil {
            Game.generateNewGame(vc: self)
        }
        guard let mainGame = Game.main else { fatalError("Main game shouldn't be nil") }
        return mainGame
    }
    
    var highScore: Score = UserDefaults.standard.scores.first ?? Score(timestamp: 0, points: 0)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get { return .lightContent }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gameAreaSizeConstraint.constant = Constants.gameAreaSizeInPoints
        setupHighScore(animated: false)
        view.backgroundColor = UIColor.Custom.background.value(for: .dark)
        view.isMultipleTouchEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refresh()
    }
    
    func scoreChanged() {
        if game.score <= highScore.points {
            scoreLabel.text = String(describing: game.score)
        } else {
            animateTakingAdvantageOfHighScore()
            highScoreLabel.text = String(describing: game.score)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if game.isPaused {
            game.resume()
        } else if game.isStopped {
            if game.gameOverTimer == nil {
                startNewGame()
            }
        } else {
            guard let touch = touches.first else { fatalError() }
            changeSnakeMoveDirectionBasedOn(touch)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !game.isPaused && !game.isStopped {
            guard let touch = touches.first else { fatalError() }
            changeSnakeMoveDirectionBasedOn(touch)
        }
    }
    
    func changeSnakeMoveDirectionBasedOn(_ touch: UITouch) {
        let touchLocation = touch.location(in: view)
        let directionToMove = getDirectionToMove(touchLocation)
        game.snake.moveDirection = directionToMove
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
        collisionObject?.removeFromSuperview()
        collisionObject = nil
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
        if let collisionPoint = game.collisionPoint {
            createCollisionObject(at: collisionPoint)
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
    
    private func createCollisionObject(at point: Point) {
        let object = CollisionObjectView()
        object.place(at: point)
        collisionObject = object
        gameAreaView.addSubview(object)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func startNewGame() {
        Game.main = nil
        scoreChanged()
        setupHighScore(animated: true)
        refresh()
    }
    
    private func setupHighScore(animated: Bool) {
        let bigTransform = CGAffineTransform(scaleX: 1, y: 1)
        let smallTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        func setupThings() {
            view.layoutIfNeeded()
            self.highScoreStackView.transform = smallTransform
            self.scoreStackView.transform = bigTransform
            self.highScoreLabel.textColor = UIColor.lightGray
            self.highScoreTitleLabel.textColor = UIColor.darkGray
            self.scoreLabel.textColor = UIColor.white
            self.scoreTitleLabel.textColor = UIColor.lightGray
        }
        self.highScoreCenterXConstraint.constant = 0
        self.scoreCenterXConstraint.constant = 0
        if animated {
            UIView.animate(withDuration: 0.3) {
                setupThings()
            }
        } else {
            setupThings()
        }
        highScore = UserDefaults.standard.scores.first ?? Score(timestamp: 0, points: 0)
        highScoreLabel.text = String(describing: highScore.points)
    }
    
    private func animateTakingAdvantageOfHighScore() {
        let bigTransform = CGAffineTransform(scaleX: 1, y: 1)
        let smallTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        let highScoreCenterX = highScoreStackView.frame.minX + highScoreStackView.frame.width / 2
        let scoreCenterX = scoreStackView.frame.minX + scoreStackView.frame.width / 2
        let difference = highScoreCenterX - scoreCenterX
        highScoreCenterXConstraint.constant = -difference
        scoreCenterXConstraint.constant = -difference
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.highScoreStackView.transform = bigTransform
            self.scoreStackView.transform = smallTransform
            self.highScoreLabel.textColor = UIColor.white
            self.highScoreTitleLabel.textColor = UIColor.lightGray
            self.scoreLabel.textColor = UIColor.lightGray
            self.scoreTitleLabel.textColor = UIColor.darkGray
        }
    }
    
    private func getLocationByPoint(_ point: Point) -> CGPoint {
        let pointInArea = CGPoint(x: CGFloat(point.x) * Constants.scale, y: CGFloat(point.y) * Constants.scale)
        let pointOnScreen = view.convert(pointInArea, from: gameAreaView)
        return pointOnScreen
    }
    
}
