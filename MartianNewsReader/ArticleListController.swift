//
//  ArticleListController.swift
//  MartianNewsReader
//
//  Copyright © 2017 NYTimes. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
    @IBOutlet weak var articleImageView: UIImageView!
    
    @IBOutlet weak var articleTitleLabel: UILabel!
    
    func downloadImage(url: URL) {
        ArticleAPI.imageManager.download(with: url) { image in
            DispatchQueue.main.async {
                self.articleImageView.image = image
            }
            
        }
    }
}

final class ArticleListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    fileprivate let CellIdentifier = "Cell"
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var languageSwitch: UISwitch!
    
    fileprivate var articleListProvider: ArticleListProvider
    
    override func viewDidLoad() {
        self.articleListProvider = ArticleListProvider()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable(notification:)), name: .articleDataLoaded, object: nil)
    }
    
    deinit {
        // Clean up observer
        NotificationCenter.default.removeObserver(self)
    }
    
    func reloadTable(notification: Notification) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }
    
    required init?(coder: NSCoder) {
        self.articleListProvider = ArticleListProvider()
        super.init(coder: coder)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleListProvider.articleCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! ArticleCell
        
        let article = articleListProvider.articleAtIndex(indexPath.row)
        cell.downloadImage(url: URL(string: article!.images[0].url)!)
        cell.articleTitleLabel?.text = article?.title
        return cell
    }
}
