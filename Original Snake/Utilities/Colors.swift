//
//  Colors.swift
//  Original Snake
//
//  Created by Bartłomiej Świerad on 21/01/2019.
//  Copyright © 2019 Bartłomiej Świerad. All rights reserved.
//

import UIKit

extension UIColor {
    enum Custom {
        case background
        
        func value(for theme: Theme) -> UIColor {
            switch self {
            case .background:
                switch theme {
                case .light:
                    return UIColor.white
                case .dark:
                    return UIColor.darkText
                }
            }
        }
    }
}
