//
//  WeakRefVirtualProxy.swift
//  EssentialFeediOS
//
//  Created by Ilhan Sari on 8.03.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import UIKit

final class WeakRefVirtualProxy<T: AnyObject> {
    
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
    func displayLoading(_ viewModel: FeedLoadingViewModel) {
        object?.displayLoading(viewModel)
    }
}

extension WeakRefVirtualProxy: FeedImageView where T: FeedImageView, T.Image == UIImage {
    func display(_ model: FeedImageViewModel<UIImage>) {
        object?.display(model)
    }
}
