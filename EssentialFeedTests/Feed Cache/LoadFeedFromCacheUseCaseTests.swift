//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Ilhan Sari on 26.01.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import XCTest
import EssentialFeed

class LoadFeedFromCacheUseCaseTests: XCTestCase {
  
  func test_doesNotDeleteMessageStoreUponCreation() {
    let (_, store) = makeSUT()
    
    XCTAssertEqual(store.receivedMessages, [])
  }
  
  func test_load_requestsCacheRetrieval() {
    let (sut, store) = makeSUT()
    
    sut.load { _ in}
    
    XCTAssertEqual(store.receivedMessages, [.retrieve])
  }
  
  func test_load_failsOnRetrievalError() {
    let (sut, store) = makeSUT()
    let retrivalError = anyNSError()
    let exp = expectation(description: "Wait for load completion")
    var receivedError: Error?
    sut.load { error in
      receivedError = error
      exp.fulfill()
    }
    store.completeRetrival(with: retrivalError)
    wait(for: [exp], timeout: 1.0)
    XCTAssertEqual(receivedError as NSError?, retrivalError)
  }
  
  // MARK: - Helpers 
  private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
    let store = FeedStoreSpy()
    let sut = LocalFeedLoader(store: store, currentDate: currentDate)
    trackForMemoryLeaks(store, file: file, line: line)
    trackForMemoryLeaks(sut, file: file, line: line)
    return (sut, store)
  }
  
  private func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
  }
}
