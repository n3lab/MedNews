//
//  Utils.swift
//  MedNews
//
//  Created by n3deep on 01.12.16.
//  Copyright © 2016 n3deep. All rights reserved.
//

import Foundation

class Utils {
    class func formatDate(date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let convertDate = formatter.date(from: date)
        formatter.dateFormat = "dd MMM yyyy, HH:mm"
        return formatter.string(from: convertDate!)
    }
}
