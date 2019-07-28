//
//  ArticleListProvider.swift
//  MartianNewsReader
//
//  Copyright © 2017 NYTimes. All rights reserved.
//

import Foundation


final class ArticleListProvider {
    
    private var articles: [Article]!
    
    
    convenience init() {
        self.init(articles: [])
        
        // get aritcles
        ArticleAPI.getData { articles in
            self.articles = articles
            NotificationCenter.default.post(name: .articleDataLoaded, object: articles)
        }
    }
    
    init(articles: [Article]) {
        self.articles = articles
        //assertionFailure("Not yet implemented.")
    }
    
    func articleCount() -> Int {
        return articles.count
    }
    
    func articleAtIndex(_ index: Int) -> Article? {
        return articles[index]
    }
    
    
}
