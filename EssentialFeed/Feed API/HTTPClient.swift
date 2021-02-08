//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by ilhan sarı on 27.12.2020.
//  Copyright © 2020 ilhan sarı. All rights reserved.
//

import Foundation

public enum HTTPClientResult {
  case success(Data, HTTPURLResponse)
  case failure(Error)
}

public protocol HTTPClient {
  
  /// The completion handler can be invoked in any thread.
  /// Clients are responsible to dispatch to appropriate threads, if needed.
  func get(from url: URL, completion:  @escaping (HTTPClientResult) -> Void)
}
