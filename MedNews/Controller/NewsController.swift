//
//  NewsController.swift
//  MedNews
//
//  Created by n3deep on 30.11.16.
//  Copyright © 2016 n3deep. All rights reserved.
//

import UIKit
import Kingfisher

class NewsController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var refreshControl : UIRefreshControl!
    var newsArray = [News]()
    
    var newsAreLoading = false
    var countPage = 1
    
    var newToSegue = News()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar:UINavigationBar! =  self.navigationController?.navigationBar
        let image = UIImage.imageFromColor(color: UIColor(red: 0/255.0, green: 174/255.0, blue: 195/255.0, alpha: 1.0))
        navBar.setBackgroundImage(image, for: UIBarMetrics.default)
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Обновляем новости...")
        refreshControl.addTarget(self, action: #selector(NewsController.refreshNews), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.tableFooterView?.isHidden = true
        
        loadNews(page: countPage)
        
    }
    
    @IBAction func reloadNewsButtonPressed(_ sender: Any) {
        countPage = 1
        loadNews(page: countPage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            if let destinationVC = segue.destination as? NewsDetailController {
                destinationVC.newToSegue = newToSegue
            }
        }
    }
    
    //helper methods
    func refreshNews() {
        countPage = 1
        loadNews(page: countPage)
    }
    
    func loadNews(page: Int) {
        APIClient.getNews(pageNumber: page, onSuccess: { success in
            self.newsArray = success
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
        }, onFailed: { errorCode in
            MessageManager.generateMessage(errorCode: errorCode, controller: self)
        })
    }
    
    //infinite scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= 0 {
            loadMore()
        }
    }
 
    func loadMore() {
        if ( !newsAreLoading ) {
            self.newsAreLoading = true
            self.activityIndicator.startAnimating()
            self.tableView.tableFooterView?.isHidden = false
            loadMoreBegin(loadMoreEnd: {(x:Int) -> () in
                            self.newsAreLoading = false
                            self.activityIndicator.stopAnimating()
                            self.tableView.tableFooterView?.isHidden = true
            })
        }
    }
    
    func loadMoreBegin(loadMoreEnd:@escaping (Int) -> ()) {
        DispatchQueue.global(qos: .default).async {
            self.countPage += 1
            APIClient.getNews(pageNumber: self.countPage, onSuccess: { success in
                    self.newsArray.append(contentsOf: success)
                    self.tableView.reloadData()
                }, onFailed: { errorCode in
                    print(errorCode)
                })
                sleep(2)
            DispatchQueue.main.async {
                loadMoreEnd(0)
            }
        }

    }
    
}

extension NewsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
        
        let news = newsArray[indexPath.row]
        cell.newsTextView.text = news.shortText
        cell.newsDateLabel.text = news.date
        cell.newsImageView?.kf.indicatorType = .activity
        cell.newsImageView?.kf.setImage(with: URL(string: news.thumbnail as String)!)
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let news = newsArray[indexPath.row]
        newToSegue = news
        performSegue(withIdentifier: "ShowDetail", sender: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
