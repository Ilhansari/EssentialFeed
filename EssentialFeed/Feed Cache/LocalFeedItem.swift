//
//  LocalFeedItem.swift
//  EssentialFeed
//
//  Created by Ilhan Sari on 25.01.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import Foundation

public struct LocalFeedItem: Equatable {
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
