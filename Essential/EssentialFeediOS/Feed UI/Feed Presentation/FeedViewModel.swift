//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Ilhan Sari on 28.02.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import EssentialFeed

final class FeedViewModel {
    
    typealias Observer<T> = (T) -> Void
    
    private let feedLoader: FeedLoader

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    var onLoadingState: Observer<Bool>?
    var onFeedLoad: Observer<[FeedImage]>?

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
