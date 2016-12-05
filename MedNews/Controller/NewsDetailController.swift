//
//  NewsDetailController.swift
//  MedNews
//
//  Created by n3deep on 30.11.16.
//  Copyright © 2016 n3deep. All rights reserved.
//

import UIKit
import Kingfisher

class NewsDetailController: UIViewController {

    var newToSegue = News()
    var spotlightArray = [News]()
    var newsDetail = NewsDetail()
    
    var fontSize = 1
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var shortTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bigTextView: UITextView!
    @IBOutlet weak var photoDescriptionLabel: UILabel!
    @IBOutlet weak var urlButton: UIButton!
    
    @IBOutlet weak var shortHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var bigHeightConstant: NSLayoutConstraint!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar:UINavigationBar! =  self.navigationController?.navigationBar
        let image = UIImage.imageFromColor(color: UIColor(red: 0/255.0, green: 174/255.0, blue: 195/255.0, alpha: 0.0))
        navBar.setBackgroundImage(image, for: UIBarMetrics.default)
        
        loadNews(id: newToSegue.id)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let navBar:UINavigationBar! =  self.navigationController?.navigationBar
        let image = UIImage.imageFromColor(color: UIColor(red: 0/255.0, green: 174/255.0, blue: 195/255.0, alpha: 1.0))
        navBar.setBackgroundImage(image, for: UIBarMetrics.default)
 
        super.viewWillDisappear(animated)
    }

    func loadNews(id: Int) {
        APIClient.getNewsFromId(id: id, onSuccess: { success in
            self.newsDetail = success.0
            self.spotlightArray = success.1
            self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
            self.tableView.reloadData()
            self.reloadNewsHeaderView()
        }, onFailed: { errorCode in
            MessageManager.generateMessage(errorCode: errorCode, controller: self)
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderToFit(tableView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if  172.0 >= scrollView.contentOffset.y {
            let navBar:UINavigationBar! =  self.navigationController?.navigationBar

            let image = UIImage.imageFromColor(color: UIColor(red: 0/255.0, green: 174/255.0, blue: 195/255.0, alpha: scrollView.contentOffset.y/172.0))
            navBar.setBackgroundImage(image, for: UIBarMetrics.default)

        }
    }
    
    
    @IBAction func urlButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: newsDetail.source)!, options: [:], completionHandler: nil)
    }
    
    @IBAction func changeSizeButtonPressed(_ sender: Any) {
        switch fontSize {
        case 1  :
            bigTextView.changeFontSize(size: 14.0)
            fontSize = 2
        case 2  :
            bigTextView.changeFontSize(size: 16.0)
            fontSize = 3
        case 3  :
            bigTextView.changeFontSize(size: 18.0)
            fontSize = 1
        default :
            bigTextView.changeFontSize(size: 14.0)
            fontSize = 2
        }
        self.reloadNewsHeaderView()
        self.tableView.reloadData()
    }
    
    func reloadNewsHeaderView() {
        newsImageView?.kf.indicatorType = .activity
        newsImageView?.kf.setImage(with: URL(string: newsDetail.image as String)!)
        
        shortTextView.text = newToSegue.shortText
        shortTextView.sizeToFit()
        print(shortTextView.contentSize.height)
        shortHeightConstant.constant = shortTextView.contentSize.height
        
        dateLabel.text = newToSegue.date
        
        photoDescriptionLabel.text = newsDetail.image_caption
        
        bigTextView.text = newsDetail.text
        bigTextView.sizeToFit()
        print(bigTextView.contentSize.height)
        bigHeightConstant.constant = bigTextView.contentSize.height
        
        //urlButton.setTitle(newsDetail.source, for: .normal)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension NewsDetailController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spotlightArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
            let news = spotlightArray[indexPath.row]
            cell.newsTextView.text = news.shortText
            cell.newsDateLabel.text = news.date
            cell.newsImageView?.kf.indicatorType = .activity
            cell.newsImageView?.kf.setImage(with: URL(string: news.thumbnail as String)!)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        newToSegue = spotlightArray[indexPath.row]
        loadNews(id: newToSegue.id)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func sizeHeaderToFit(_ tableView: UITableView) {
        if let headerView = tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame
            tableView.tableHeaderView = headerView
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
        }
    }
    
}
