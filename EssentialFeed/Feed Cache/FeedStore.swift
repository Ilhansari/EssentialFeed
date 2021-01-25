//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Ilhan Sari on 24.01.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import Foundation

public protocol FeedStore {
  
  typealias DeletionCompletion = (Error?) -> Void
  typealias InsertionCompletion = (Error?) -> Void
  
  func deletedCache(completion: @escaping (DeletionCompletion))
  func insert(_ item: [LocalFeedItem], timestamp: Date, completion: @escaping InsertionCompletion)
  
}
