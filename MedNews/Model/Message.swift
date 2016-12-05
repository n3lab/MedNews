//
//  Message.swift
//  MedNews
//
//  Created by n3deep on 01.12.16.
//  Copyright © 2016 n3deep. All rights reserved.
//

import Foundation
import UIKit

class Message {
    class func showMessage(messageString: String, controller: UIViewController) {
        let alert = UIAlertController(title: "Сообщение",
                                      message: messageString,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        controller.present(alert, animated: true, completion: nil)
    }
}
