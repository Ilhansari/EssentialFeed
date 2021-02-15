//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Ilhan Sari on 25.01.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
 internal let id: UUID
 internal let description: String?
 internal let location: String?
 internal let image: URL
}
