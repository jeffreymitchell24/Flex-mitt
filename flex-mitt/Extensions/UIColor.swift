//
//  UIColor.swift
//  flex-mitt
//
//  Created by Seweryn Katolyk on 8/25/18.
//  Copyright © 2018 Flex-Sports. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(rgbValue: UInt) {
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255,
                  alpha: 1)
    }
}
