//
//  FeedItemMapper.swift
//  EssentialFeed
//
//  Created by ilhan sarı on 27.12.2020.
//  Copyright © 2020 ilhan sarı. All rights reserved.
//

import Foundation

internal final class FeedItemMapper {
  struct Root: Decodable {
    let items: [RemoteFeedImage]
  }

  private static var OK_200: Int { return 200}

  internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedImage] {
    guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
      throw RemoteFeedLoader.Error.invalidData
    }

    return root.items

  }
}
