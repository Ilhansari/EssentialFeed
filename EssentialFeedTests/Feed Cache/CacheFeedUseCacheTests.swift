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
    sut.save(uniqueImageFeed().models) { _ in}
    XCTAssertEqual(store.receivedMessages, [.deletedCacheFeed])
  }
  
  func test_saveDoesNotRequestCacheInsertionOnDeletionError() {
    let (sut, store) = makeSUT()
    let deletionError = anyNSError()
    
    sut.save(uniqueImageFeed().models) { _ in}
    store.completeDeletion(with: deletionError)
    
    XCTAssertEqual(store.receivedMessages, [.deletedCacheFeed])
  }
  
  func test_saveRequestNewCacheInsertionWithTimestampSuccesfullyDeletion() {
    let timestamp = Date()
    let feed = uniqueImageFeed()
    let (sut, store) = makeSUT(currentDate: { timestamp })
    
    sut.save(feed.models) { _ in}
    store.completeDeletionSuccessfully()
    
    XCTAssertEqual(store.receivedMessages, [.deletedCacheFeed, .insert(feed.local, timestamp)])
  }
  
  func test_save_doesNotDeliverDeletionErrorAfterSUTInstanceHasBeenDeallocated() {
    let store = FeedStoreSpy()
    var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
    
    var receivedResults = [LocalFeedLoader.SaveResult]()
    sut?.save(uniqueImageFeed().models) { error in
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
    sut?.save(uniqueImageFeed().models) { error in
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
    sut.save([uniqueImage()]) { error in
      receivedError = error
      exp.fulfill()
    }
    
    action()
    
    wait(for: [exp], timeout: 1.0)
    
    XCTAssertEqual(receivedError as NSError?, expectedError)
  }
  
  private func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
  }
  
  private func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let feed = [uniqueImage(), uniqueImage()]
    let localItems = feed.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    return (feed, localItems)
  }
  
  private func anyURL() -> URL {
    let url = URL(string: "www.any-url.com")!
    return url
  }
  
  private func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
  }
  
}
