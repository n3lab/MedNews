//
//  UITextViewExtension.swift
//  MedNews
//
//  Created by n3deep on 01.12.16.
//  Copyright © 2016 n3deep. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    func changeFontSize(size: CGFloat ) {
        self.font =  UIFont(name: (self.font?.fontName)!, size: size)!
    }
}
