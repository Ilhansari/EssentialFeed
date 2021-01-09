//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by ilhan sarı on 20.12.2020.
//  Copyright © 2020 ilhan sarı. All rights reserved.
//

import Foundation

public struct FeedItem: Equatable {
  public let id: UUID
  public let description: String?
  public let location: String?
  public let imageURL: URL

  public init(id: UUID, description: String?, location: String?, imageURL: URL) {
    self.id = id
    self.description = description
    self.location = location
    self.imageURL = imageURL
  }
}
