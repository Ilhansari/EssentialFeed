//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Ilhan Sari on 28.02.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import EssentialFeed

protocol FeedLoadingView {
    func displayLoading(_ viewModel: FeedLoadingViewModel)
}

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

final class FeedPresenter {

    private let feedView: FeedView
    private let loadingView: FeedLoadingView
    
    init(feedView: FeedView, loadingView: FeedLoadingView) {
        self.feedView = feedView
        self.loadingView = loadingView
    }
    
    func didStartLoadingview() {
        loadingView.displayLoading(FeedLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingView(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.displayLoading(FeedLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingFeed(with error: Error) {
        loadingView.displayLoading(FeedLoadingViewModel(isLoading: false))
    }
}
