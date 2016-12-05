//
//  UIImageExtension.swift
//  MedNews
//
//  Created by n3deep on 01.12.16.
//  Copyright © 2016 n3deep. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static func imageFromColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
    }
}
