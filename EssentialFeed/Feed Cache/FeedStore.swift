//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Ilhan Sari on 24.01.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import Foundation

public enum RetrieveCachedFeedResult {
  case empty
  case found(feed: [LocalFeedImage], timestamp: Date)
  case failure(Error)
}


public protocol FeedStore {
  
  typealias DeletionCompletion = (Error?) -> Void
  typealias InsertionCompletion = (Error?) -> Void
  typealias RetrivalCompletion = (RetrieveCachedFeedResult) -> Void
  
  func deletedCache(completion: @escaping (DeletionCompletion))
  func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
  func retrieve(completion: @escaping (RetrivalCompletion))
  
}
