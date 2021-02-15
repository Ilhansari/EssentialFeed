//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Ilhan Sari on 29.01.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import Foundation

func anyNSError() -> NSError {
 return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
 let url = URL(string: "www.any-url.com")!
 return url
}
