//
//  FeedStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Ilhan Sari on 26.01.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import Foundation
import EssentialFeed

class FeedStoreSpy: FeedStore {
  
  enum ReceivedMessages: Equatable {
    case deletedCacheFeed
    case insert([LocalFeedImage], Date)
    case retrieve
  }
  
  private(set) var receivedMessages = [ReceivedMessages]()
  
  private var deletionCompletions = [DeletionCompletion]()
  private var insertionCompletions = [InsertionCompletion]()
  private var retrivalCompletions = [RetrivalCompletion]()
  
  func deletedCache(completion: @escaping (DeletionCompletion)) {
    deletionCompletions.append(completion)
    receivedMessages.append(.deletedCacheFeed)
  }
  
  func completeDeletion(with error: Error, at index: Int = 0) {
    deletionCompletions[index](error)
  }
  
  func completeDeletionSuccessfully(at index: Int = 0) {
    deletionCompletions[index](nil)
  }
  
  func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
    insertionCompletions.append(completion)
    receivedMessages.append(.insert(feed, timestamp))
  }
  
  func completeInsertion(with error: Error, at index: Int = 0) {
    insertionCompletions[index](error)
  }
  
  func completeSuccessfully(at index: Int = 0) {
    insertionCompletions[index](nil)
  }
  
  func retrieve(completion: @escaping RetrivalCompletion) {
    retrivalCompletions.append(completion)
    receivedMessages.append(.retrieve)
  }
  
  
  func completeRetrival(with error: Error, at index: Int = 0) {
    retrivalCompletions[index](.failure(error))
  }
  
  func completeRetrivalWithEmptyCache(at index: Int = 0) {
    retrivalCompletions[index](.empty)
  }
  
  func completeRetrival(with feed: [LocalFeedImage], timestamp: Date, at index: Int = 0) {
    retrivalCompletions[index](.found(feed: feed, timestamp: timestamp))
  }
}

