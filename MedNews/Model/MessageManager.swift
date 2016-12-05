//
//  MessageManager.swift
//  MedNews
//
//  Created by n3deep on 01.12.16.
//  Copyright © 2016 n3deep. All rights reserved.
//

import Foundation
import UIKit

class MessageManager {
    class func generateMessage(errorCode: Int, controller: UIViewController) {
        switch errorCode {
        case 401:
            Message.showMessage(messageString: "Ошибка авторизации", controller: controller)
        case 404:
            Message.showMessage(messageString: "Новости не найдены", controller: controller)
        default:
            Message.showMessage(messageString: "Ошибка сервера", controller: controller)
        }
    }
}

