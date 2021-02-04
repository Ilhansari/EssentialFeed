//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Ilhan Sari on 4.02.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import XCTest
import EssentialFeed

class CodableFeedStore {
  func retrieve(completion: @escaping (FeedStore.RetrivalCompletion)) {
    completion(.empty)
  }
}
class CodableFeedStoreTests: XCTestCase {
 
  func test_retrieve_deliversEmptyOnEmptyCache() {
    let sut = CodableFeedStore()
    let exp = expectation(description: "Wait for cache retrieval")
    sut.retrieve { result in
      switch result {
      case .empty:
        break
      default:
        XCTFail("Expected empty result, got \(result) instead")
      }
      exp.fulfill()
    }
    wait(for: [exp], timeout: 1.0)
  }
}
