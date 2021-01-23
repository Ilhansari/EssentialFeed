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
  
  func completeSuccessfully(at index: Int = 0) {
    insertionCompletions[index](nil)
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
    let (sut, store) = makeSUT()
    let deletionError = anyNSError()
    
    expect(sut, toCompleteWithError: deletionError) {
      store.completeDeletion(with: deletionError)
    }
  }
  
  func test_failsOnInsertionError() {
    let (sut, store) = makeSUT()
    let insertionError = anyNSError()
    
    expect(sut, toCompleteWithError: insertionError) {
      store.completeDeletionSuccessfully()
      store.completeInsertion(with: insertionError)
    }
  }
  
  func test_succedsOnSuccessfulCacheInsertion() {
    let (sut, store) = makeSUT()
    expect(sut, toCompleteWithError: nil) {
      store.completeDeletionSuccessfully()
      store.completeSuccessfully()
    }
  }
  // MARK: - Helpers
  
  private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
    let store = FeedStore()
    let sut = LocalFeedLoader(store: store, currentDate: currentDate)
    trackForMemoryLeaks(store, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return (sut, store)
  }
  
  private func expect(_ sut: LocalFeedLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
    let exp = expectation(description: "wait for save completion")
    
    var receivedError: Error?
    sut.save([uniqueItem()]) { error in
      receivedError = error
      exp.fulfill()
    }
    
    action()
  
    wait(for: [exp], timeout: 1.0)
    
   XCTAssertEqual(receivedError as NSError?, expectedError)
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
