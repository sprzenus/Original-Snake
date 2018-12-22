//
//  TriangleView.swift
//  Original Snake
//
//  Created by Bartłomiej Świerad on 22/12/2018.
//  Copyright © 2018 Bartłomiej Świerad. All rights reserved.
//

import UIKit

class TriangleView: UIView {
    
    var color: UIColor = .red
    var firstPoint: CGPoint = CGPoint(x: 0, y: 0)
    var secondPoint: CGPoint = CGPoint(x: 0.5, y: 1)
    var thirdPoint: CGPoint = CGPoint(x: 1, y: 0)
    
    public func setup(firstPoint: CGPoint, secondPoint: CGPoint, thirdPoint: CGPoint, color: UIColor) {
        self.firstPoint = firstPoint
        self.secondPoint = secondPoint
        self.thirdPoint = thirdPoint
        self.color = color
    }
    
    override func draw(_ rect: CGRect) {
        let aPath = UIBezierPath()
        aPath.move(to: CGPoint(x: self.firstPoint.x * rect.width, y: self.firstPoint.y * rect.height))
        aPath.addLine(to: CGPoint(x: self.secondPoint.x * rect.width, y: self.secondPoint.y * rect.height))
        aPath.addLine(to: CGPoint(x: self.thirdPoint.x * rect.width, y: self.thirdPoint.y * rect.height))
        aPath.close()
        self.color.set()
        self.backgroundColor = .clear
        aPath.fill()
    }
    
}
