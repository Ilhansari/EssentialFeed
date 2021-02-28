//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Ilhan Sari on 27.02.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import UIKit

final class FeedRefreshViewController: NSObject {

    private(set) lazy var view = binded(UIRefreshControl())
    
    private let viewModel: FeedViewModel
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    @objc func refresh() {
        viewModel.loadFeed()
    }
    
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl {
        viewModel.onLoadingState = { [weak self] isLoading in
            if isLoading {
                self?.view.beginRefreshing()
            } else {
                self?.view.endRefreshing()
            }
        }
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
