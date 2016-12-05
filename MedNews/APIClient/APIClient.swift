//
//  APIClient.swift
//  MedNews
//
//  Created by n3deep on 30.11.16.
//  Copyright © 2016 n3deep. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftSpinner

class APIClient {

    class func getNews(pageNumber: Int, onSuccess: @escaping ([News]) -> Void, onFailed: @escaping (Int) -> Void) {
        let headers: HTTPHeaders = [
            "API-KEY": secretAuthKey
        ]
        Alamofire.request("\(apiURL)/news?page=\(pageNumber)&per_page=\(newsPerPage)", method: .get, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                
                var newsArray = [News]()
                
                for i in 1..<json["data"].count {
                    let news = News()
                    news.shortText = json["data"][i]["title"].string!
                    news.thumbnail = json["data"][i]["thumbnail"].string!
                    news.date = Utils.formatDate(date: json["data"][i]["created_at"].string!)
                    news.id = json["data"][i]["id"].int!
                    newsArray.append(news)
                }
                
                onSuccess(newsArray)
            case .failure:
                let errorCode = (response.response?.statusCode)! as Int
                onFailed(errorCode)
            }
        }
    }
    
    class func getNewsFromId(id: Int, onSuccess: @escaping (NewsDetail, [News]) -> Void, onFailed: @escaping (Int) -> Void) {
        SwiftSpinner.show("Загрузка...")
        let headers: HTTPHeaders = [
            "API-KEY": secretAuthKey
        ]
        Alamofire.request("\(apiURL)/news/\(id)", method: .get, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success:
                let json = JSON(response.result.value!)
                
                print(json)
                var newsArray = [News]()
                
                let newsDetail = NewsDetail()
                newsDetail.text = json["data"]["text"].string!
                newsDetail.image = json["data"]["image"].string!
                newsDetail.source = json["data"]["source"].string!
                newsDetail.id = json["data"]["id"].int!
                newsDetail.image_caption = json["data"]["image_caption"].string!
 
                for i in 1..<json["spotlight"].count {
                    let news = News()
                    news.shortText = json["spotlight"][i]["title"].string!
                    news.thumbnail = json["spotlight"][i]["thumbnail"].string!
                    news.date = Utils.formatDate(date: json["spotlight"][i]["created_at"].string!)
                    news.id = json["spotlight"][i]["id"].int!
                    newsArray.append(news)
                }
 
                onSuccess(newsDetail, newsArray)
                SwiftSpinner.hide()
            case .failure:
                let errorCode = (response.response?.statusCode)! as Int
                onFailed(errorCode)
                SwiftSpinner.hide()
            }
        }
    }
    
    
}
