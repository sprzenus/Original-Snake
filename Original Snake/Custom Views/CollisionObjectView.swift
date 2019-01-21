//
//  CollisionObjectView.swift
//  Original Snake
//
//  Created by Bartłomiej Świerad on 21/01/2019.
//  Copyright © 2019 Bartłomiej Świerad. All rights reserved.
//

import UIKit

class CollisionObjectView: ObjectView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.alpha = 1
        animate(true)
    }
    
    func animate(_: Bool) {
        UIView.animate(withDuration: 0.6, animations: {
            self.alpha = 0
        }) { _ in
            UIView.animate(withDuration: 0.6, animations: {
                self.alpha = 1
            }, completion: self.animate)
        }
    }
    
    override var objectColor: UIColor {
        return UIColor.red
    }
}
