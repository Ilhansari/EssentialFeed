//
//  URLSessionHTTPClient.swift
//  EssentialFeed
//
//  Created by ilhan sarı on 6.01.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {

    var session: URLSession

    public init(session: URLSession) {
        self.session = session
    }

    private struct UnExpectedValuesRepresentaion: Error { }

    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask

        func cancel() {
            wrapped.cancel()
        }
    }

    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result { if let error = error {
                throw error
            } else {
                throw UnExpectedValuesRepresentaion()
            }})
        }
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)

    }
}
