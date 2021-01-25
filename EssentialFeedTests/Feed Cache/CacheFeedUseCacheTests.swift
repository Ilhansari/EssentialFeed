//
//  CacheFeedUseCacheTests.swift
//  EssentialFeedTests
//
//  Created by Ilhan Sari on 22.01.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import XCTest
import EssentialFeed

class CacheFeedUseCacheTests: XCTestCase {
  
  func test_doesNotDeleteMessageStoreUponCreation() {
    let (_, store) = makeSUT()
    XCTAssertEqual(store.receivedMessages, [])
  }
  
  func test_requestsCacheDeletion() {
    let (sut, store) = makeSUT()
    sut.save(uniqueItems().models) { _ in}
    XCTAssertEqual(store.receivedMessages, [.deletedCacheFeed])
  }
  
  func test_saveDoesNotRequestCacheInsertionOnDeletionError() {
    let (sut, store) = makeSUT()
    let deletionError = anyNSError()
    
    sut.save(uniqueItems().models) { _ in}
    store.completeDeletion(with: deletionError)
    
    XCTAssertEqual(store.receivedMessages, [.deletedCacheFeed])
  }
  
  func test_saveRequestNewCacheInsertionWithTimestampSuccesfullyDeletion() {
    let timestamp = Date()
    let items = uniqueItems()
    let (sut, store) = makeSUT(currentDate: { timestamp })
    
    sut.save(items.models) { _ in}
    store.completeDeletionSuccessfully()
    
    XCTAssertEqual(store.receivedMessages, [.deletedCacheFeed, .insert(items.local, timestamp)])
  }
  
  func test_save_doesNotDeliverDeletionErrorAfterSUTInstanceHasBeenDeallocated() {
    let store = FeedStoreSpy()
    var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
    
    var receivedResults = [LocalFeedLoader.SaveResult]()
    sut?.save(uniqueItems().models) { error in
      receivedResults.append(error)
    }
    sut = nil
    store.completeDeletion(with: anyNSError())
    
    XCTAssertTrue(receivedResults.isEmpty)
  }
  
  func test_save_doesNotDeliverInsertiOnErrorAfterSUTInstanceHasBeenDeallocated() {
    let store = FeedStoreSpy()
    var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
    
    var receivedResults = [LocalFeedLoader.SaveResult]()
    sut?.save(uniqueItems().models) { error in
      receivedResults.append(error)
    }
    store.completeDeletionSuccessfully()
    sut = nil
    store.completeInsertion(with: anyNSError())
    
    XCTAssertTrue(receivedResults.isEmpty)
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
  
  private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
    let store = FeedStoreSpy()
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
  
  private func uniqueItems() -> (models: [FeedItem], local: [LocalFeedItem]) {
    let items = [uniqueItem(), uniqueItem()]
    let localItems = items.map { LocalFeedItem(id: $0.id, description: $0.description, location: $0.location, imageURL: $0.imageURL) }
    return (items, localItems)
  }
  
  private class FeedStoreSpy: FeedStore {
    
    enum ReceivedMessages: Equatable {
      case deletedCacheFeed
      case insert([LocalFeedItem], Date)
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
    
    func insert(_ item: [LocalFeedItem], timestamp: Date, completion: @escaping InsertionCompletion) {
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
  
  private func anyURL() -> URL {
    let url = URL(string: "www.any-url.com")!
    return url
  }
  
  private func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
  }
  
}
