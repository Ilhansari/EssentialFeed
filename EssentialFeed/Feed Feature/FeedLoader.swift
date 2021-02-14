//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by ilhan sarı on 20.12.2020.
//  Copyright © 2020 ilhan sarı. All rights reserved.
//

import Foundation

public protocol FeedLoader {
    typealias Result =  Swift.Result<[FeedImage], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
