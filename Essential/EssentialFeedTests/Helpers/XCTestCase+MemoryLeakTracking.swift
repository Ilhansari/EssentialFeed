//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialFeedTests
//
//  Created by ilhan sarı on 6.01.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import XCTest

extension XCTestCase {
  func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
     addTeardownBlock { [weak instance] in
       XCTAssertNil(instance, "Instance should have been deallocated.Potential memory leak.", file: file, line: line)
     }
   }
}
