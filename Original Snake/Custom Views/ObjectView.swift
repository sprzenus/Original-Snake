//
//  ObjectView.swift
//  Original Snake
//
//  Created by Bartłomiej Świerad on 04/12/2018.
//  Copyright © 2018 Bartłomiej Świerad. All rights reserved.
//

import UIKit

class ObjectView: UIView {
    
    var objectColor: UIColor {
        return .white
    }
    
    init(size: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init() {
        self.init(size: Constants.scale)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        backgroundColor = .clear
        
        let subview = UIView()
        subview.backgroundColor = objectColor
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let multiplier: CGFloat = 0.8
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: centerYAnchor),
            subview.widthAnchor.constraint(equalTo: widthAnchor, multiplier: multiplier),
            subview.heightAnchor.constraint(equalTo: heightAnchor, multiplier: multiplier),
            ])
    }
    
    public func placeInPoints(x: CGFloat, y: CGFloat) {
        frame.origin = CGPoint(x: x, y: y)
    }
    
    public func place(at point: Point) {
        place(x: point.x, y: point.y)
    }
    
    public func place(x: Int, y: Int) {
        frame.origin = CGPoint(x: CGFloat(x) * Constants.scale, y: CGFloat(y) * Constants.scale)
    }

}
