//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Ilhan Sari on 28.02.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import Foundation
import EssentialFeed

final class FeedViewModel {
    private let feedLoader: FeedLoader

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    
    var onLoadingState: ((Bool) -> Void)?
    var onFeedLoad: (([FeedImage]) -> Void)?


    func loadFeed() {
        onLoadingState?(true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }
            self?.onLoadingState?(false)
        }
    }
}
