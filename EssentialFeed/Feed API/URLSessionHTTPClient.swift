//
//  URLSessionHTTPClient.swift
//  EssentialFeed
//
//  Created by ilhan sarı on 6.01.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {

  var session: URLSession

  public init(session: URLSession = .shared) {
    self.session = session
  }

  private struct UnExpectedValuesRepresentaion: Error { }

  public func get(from url: URL, completion completionHandler: @escaping (HTTPClientResult) -> Void) {
    session.dataTask(with: url) { (data, response, error) in
      if let error = error {
        completionHandler(.failure(error))
      } else if let data = data, let response = response as? HTTPURLResponse {
        completionHandler(.success(data, response))
      } else {
        completionHandler(.failure(UnExpectedValuesRepresentaion()))
      }
    }.resume()
  }
}
