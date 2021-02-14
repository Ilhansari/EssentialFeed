//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by ilhan sarı on 20.12.2020.
//  Copyright © 2020 ilhan sarı. All rights reserved.
//

import Foundation

public typealias LoadFeedResult =  Result<[FeedImage], Error>

public protocol FeedLoader {
  func load(completion: @escaping (LoadFeedResult) -> Void)
}
