//
//  UIImage+Tint.swift
//  Sarah
//
//  Created by Alex on 05/02/16.
//  Copyright © 2016 appswithlove. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func imageTinted(color:UIColor, fraction:Float = 0) -> UIImage {
        var image:UIImage
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        var rect = CGRectZero
        rect.size = self.size
        color.set()
        UIRectFill(rect)
        self.drawInRect(rect, blendMode: .DestinationIn, alpha: 1)
        if fraction > 0 {
            self.drawInRect(rect, blendMode: .SourceAtop, alpha: CGFloat(fraction))
        }
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

func +(left: UIImage, right: UIColor) -> UIImage {
    return left.imageTinted(right)
}