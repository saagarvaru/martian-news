//
//  ArticleViewController.swift
//  MartianNewsReader
//
//  Copyright © 2017 NYTimes. All rights reserved.
//

import UIKit

final class ArticleViewController: UIViewController, UIScrollViewDelegate {
    
    var article: Article?
    
    @IBOutlet var articleScrollView: UIScrollView!
    @IBOutlet weak var articleImageView: UIImageView!
    
    @IBOutlet weak var articleTitleLabel: UILabel!
    
    @IBOutlet weak var articleBodyLabel: UILabel!
    var articleImage: UIImage? = nil
    
    var translate = true
    
    override func viewDidLoad() {
        self.navigationItem.title = article?.title
        self.articleTitleLabel.text = article?.title
        self.articleBodyLabel.text = article?.body
        self.articleBodyLabel.sizeToFit()
        ArticleAPI.imageManager.download(with: URL(string: (article?.images[0].url)!)!) { image in
            self.articleImageView.image = image
        }
        self.articleScrollView.contentSize = articleScrollView.subviews.reduce(CGRect.zero,{
            return $0.union($1.frame)
        }).size
        
        if (self.translate) {
            self.articleTitleLabel.text = TranslationHelper.translateToMartian(textToTranslate: article!.title)
            self.articleBodyLabel.text = TranslationHelper.translateToMartian(textToTranslate: article!.body)
        }
    
    }
}
