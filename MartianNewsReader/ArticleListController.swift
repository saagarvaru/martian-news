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
    
    private var isMartian = false
    
    override func viewDidLoad() {
        self.articleListProvider = ArticleListProvider()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable(notification:)), name: .articleDataLoaded, object: nil)
    }
    
    @IBAction func toggleLanguage(_ sender: Any) {
        if self.isMartian {
            self.isMartian = false
        } else {
            self.isMartian = true
        }
        reloadTable()
    }
    deinit {
        // Clean up observer
        NotificationCenter.default.removeObserver(self)
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func reloadTable(notification: Notification) {
        reloadTable()
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
        if (!self.isMartian) {
            cell.articleTitleLabel?.text = article?.title
        } else {
            cell.articleTitleLabel?.text = TranslationHelper.translateToMartian(textToTranslate: article!.title)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openArticle" {
            let index = self.tableView.indexPathForSelectedRow?.row
            let destination = segue.destination as? ArticleViewController
            let article = articleListProvider.articleAtIndex(index!)
            destination?.article = article
            destination?.translate = self.isMartian
        }
    }
}
