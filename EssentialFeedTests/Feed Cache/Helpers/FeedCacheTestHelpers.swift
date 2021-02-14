//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Ilhan Sari on 29.01.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import Foundation
import EssentialFeed

 func uniqueImage() -> FeedImage {
  return FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
}

 func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
  let feed = [uniqueImage(), uniqueImage()]
  let localItems = feed.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
  return (feed, localItems)
}



extension Date {
  func minusFeedCacheMaxAge() -> Date {
    return adding(days: -feedCacheMaxAgeInDays)
  }
  
  private var feedCacheMaxAgeInDays: Int {
    return 7
  }
  
  private func adding(days: Int) -> Date {
    return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
  }
}

extension Date {
  func adding(seconds: TimeInterval) -> Date {
    return self + seconds
  }
}
