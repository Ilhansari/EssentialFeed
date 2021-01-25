//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Ilhan Sari on 24.01.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import Foundation

public final class LocalFeedLoader {
  private let store: FeedStore
  private let currentDate: () -> Date
  
  public typealias SaveResult = Error?
  public init(store: FeedStore, currentDate: @escaping () -> Date) {
    self.store = store
    self.currentDate = currentDate
  }
  
  public func save(_ item: [FeedItem], completion: @escaping (SaveResult) -> Void) {
    store.deletedCache { [weak self] error in
      guard let self = self else { return }
      if let cacheDeletionError = error {
        completion(cacheDeletionError)
      } else {
        self.cache(item, with: completion)
      }
    }
  }
  
  private func cache(_ items: [FeedItem],  with completion: @escaping (SaveResult) -> Void) {
    self.store.insert(items.toLocal(), timestamp: currentDate()) { [weak self]  error in
      guard self != nil else { return }
      completion(error)
    }
  }
}

private extension Array where Element == FeedItem {
  func toLocal() -> [LocalFeedItem] {
    return map { LocalFeedItem(id: $0.id, description: $0.description, location: $0.location, imageURL: $0.imageURL)}
  }
}
