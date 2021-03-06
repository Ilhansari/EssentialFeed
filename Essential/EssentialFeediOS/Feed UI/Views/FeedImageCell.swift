//
//  FeedImageCell.swift
//  EssentialFeediOS
//
//  Created by Ilhan Sari on 24.02.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import UIKit

public final class FeedImageCell: UITableViewCell {
    @IBOutlet private(set) public var locationContainer: UIView!
        @IBOutlet private(set) public var locationLabel: UILabel!
        @IBOutlet private(set) public var feedImageContainer: UIView!
        @IBOutlet private(set) public var feedImageView: UIImageView!
        @IBOutlet private(set) public var feedImageRetryButton: UIButton!
        @IBOutlet private(set) public var descriptionLabel: UILabel!
    
 
    var onRetry: (() -> Void)?
    
    @IBAction func retryButtonTapped() {
        onRetry?()
    }
}
