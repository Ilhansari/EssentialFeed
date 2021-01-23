//
//  CacheFeedUseCacheTests.swift
//  EssentialFeedTests
//
//  Created by Ilhan Sari on 22.01.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import XCTest
import EssentialFeed

class LocalFeedLoader {
  let store: FeedStore
  
  init(store: FeedStore) {
    self.store = store
  }
  
  func save(_ item: [FeedItem]) {
    store.deletedCache()
  }
}

class FeedStore {
  var deleteCachedFeedCallCount = 0
  
  func deletedCache() {
    deleteCachedFeedCallCount += 1
  }
}

class CacheFeedUseCacheTests: XCTestCase {
  
  
  func test_doesNotDeleteCacheUponCreation() {
    let (_, store) = makeSUT()
    XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
  }
  
  func test_requestsCacheDeletion() {
    let items = [uniqueItem(), uniqueItem()]
    let (sut, store) = makeSUT()
    sut.save(items)
    XCTAssertEqual(store.deleteCachedFeedCallCount, 1)
  }
  
  // MARK: - Helpers
  
  private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
    let store = FeedStore()
    let sut = LocalFeedLoader(store: store)
    trackForMemoryLeaks(store, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return (sut, store)
  }
  
  private func uniqueItem() -> FeedItem {
    return FeedItem(id: UUID(), description: "any", location: "any", imageURL: anyURL())
  }
    
  private func anyURL() -> URL {
    let url = URL(string: "www.any-url.com")!
    return url
  }
}