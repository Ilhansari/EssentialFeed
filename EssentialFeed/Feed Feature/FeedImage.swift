//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by ilhan sarı on 20.12.2020.
//  Copyright © 2020 ilhan sarı. All rights reserved.
//

import Foundation

public struct FeedImage: Equatable {
  public let id: UUID
  public let description: String?
  public let location: String?
  public let url: URL

  public init(id: UUID, description: String?, location: String?, url: URL) {
    self.id = id
    self.description = description
    self.location = location
    self.url = url
  }
}
