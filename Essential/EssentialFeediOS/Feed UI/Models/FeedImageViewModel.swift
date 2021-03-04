//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Ilhan Sari on 4.03.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import Foundation

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}
