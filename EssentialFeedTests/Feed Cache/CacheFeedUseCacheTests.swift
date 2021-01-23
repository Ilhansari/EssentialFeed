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
  private let store: FeedStore
  private let currentDate: () -> Date
  
  init(store: FeedStore, currentDate: @escaping () -> Date) {
    self.store = store
    self.currentDate = currentDate
  }
  
  func save(_ item: [FeedItem], completion: @escaping (Error?) -> Void) {
    store.deletedCache { [unowned self] error in
      if error == nil {
        self.store.insert(item, timestamp: currentDate(), completion: completion)
      } else {
        completion(error)
      }
    }
  }
}

class FeedStore {
  typealias DeletionCompletion = (Error?) -> Void
  typealias InsertionCompletion = (Error?) -> Void
  
  enum ReceivedMessages: Equatable {
    case deletedCacheFeed
    case insert([FeedItem], Date)
  }
  
  private(set) var receivedMessages = [ReceivedMessages]()
  
  private var deletionCompletions = [DeletionCompletion]()
  private var insertionCompletions = [InsertionCompletion]()
  
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
  
  func insert(_ item: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion) {
    insertionCompletions.append(completion)
    receivedMessages.append(.insert(item, timestamp))
  }
  
  func completeInsertion(with error: Error, at index: Int = 0) {
    insertionCompletions[index](error)
  }
  
}

class CacheFeedUseCacheTests: XCTestCase {
  
  func test_doesNotDeleteMessageStoreUponCreation() {
    let (_, store) = makeSUT()
    XCTAssertEqual(store.receivedMessages, [])
  }
  
  func test_requestsCacheDeletion() {
    let items = [uniqueItem(), uniqueItem()]
    let (sut, store) = makeSUT()
    sut.save(items) { _ in}
    XCTAssertEqual(store.receivedMessages, [.deletedCacheFeed])
  }
  
  func test_saveDoesNotRequestCacheInsertionOnDeletionError() {
    let items = [uniqueItem(), uniqueItem()]
    let (sut, store) = makeSUT()
    let deletionError = anyNSError()
    
    sut.save(items) { _ in}
    store.completeDeletion(with: deletionError)
    
    XCTAssertEqual(store.receivedMessages, [.deletedCacheFeed])
  }
    
  func test_saveRequestNewCacheInsertionWithTimestampSuccesfullyDeletion() {
    let timestamp = Date()
    let items = [uniqueItem(), uniqueItem()]
    let (sut, store) = makeSUT(currentDate: { timestamp })
    
    sut.save(items) { _ in}
    store.completeDeletionSuccessfully()
    
    XCTAssertEqual(store.receivedMessages, [.deletedCacheFeed, .insert(items, timestamp)])
  }
  
  func test_failsOnDeletionError() {
    let items = [uniqueItem(), uniqueItem()]
    let (sut, store) = makeSUT()
    let deletionError = anyNSError()
    let exp = expectation(description: "wait for save completion")
    
    var receivedError: Error?
    sut.save(items) { error in
      receivedError = error
      exp.fulfill()
    }
    
    store.completeDeletion(with: deletionError)
    wait(for: [exp], timeout: 1.0)
    
    XCTAssertEqual(receivedError as NSError?, deletionError)
  }
  
  func test_failsOnInsertionError() {
    let items = [uniqueItem(), uniqueItem()]
    let (sut, store) = makeSUT()
    let insertionError = anyNSError()
    let exp = expectation(description: "wait for save completion")
    
    var receivedError: Error?
    sut.save(items) { error in
      receivedError = error
      exp.fulfill()
    }
    
    store.completeDeletionSuccessfully()
    store.completeInsertion(with: insertionError)
    
    wait(for: [exp], timeout: 1.0)
    
    XCTAssertEqual(receivedError as NSError?, insertionError)
  }
  
  // MARK: - Helpers
  
  private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
    let store = FeedStore()
    let sut = LocalFeedLoader(store: store, currentDate: currentDate)
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
  
  private func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
  }

}
