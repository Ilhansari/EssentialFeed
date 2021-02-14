//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by ilhan sarı on 21.12.2020.
//  Copyright © 2020 ilhan sarı. All rights reserved.
//

import XCTest
import EssentialFeed

class LoadFeedFromRemoteUseCaseTests: XCTestCase {

  func test_init_doesNotRequestDataFromUrl() {
    let (_, client) = makeSUT()

    XCTAssertTrue(client.requestUrls.isEmpty)
  }

  func test_load_requestsDataFromUrl() {
    let url = URL(string: "wwww.a-given-url.com")!
    let (sut, client) = makeSUT(url: url)

    sut.load { _ in}
    XCTAssertEqual(client.requestUrls, [url])
    
  }

  func test_loadTwice_requestsDataFromUrl() {
    let url = URL(string: "wwww.a-given-url.com")!
    let (sut, client) = makeSUT(url: url)

    sut.load { _ in}
    sut.load { _ in}
    XCTAssertEqual(client.requestUrls, [url, url])
  }

  func test_load_deliversErrorOnClientError() {
    let (sut, client) = makeSUT()

    expect(sut, toCompleteWith: failure(.connectivity), when: {
      let clientError = NSError(domain: "Test", code: 0)
      client.complete(with: clientError)
    })
  }

  func test_load_deliversErrorOnNon200HTTPResponse() {
    let (sut, client) = makeSUT()

    let samples = [199, 201, 300, 400, 500]

    samples.enumerated().forEach { (index, code) in
      expect(sut, toCompleteWith: failure(.invalidData), when: {
        let json = makeItemsJSON([])
        client.complete(withStatusCode: code, data: json, at: index)
      })
    }
  }

  func test_load_deliversErrorOnNon200HTTPResponseWithInvalidJSON() {
    let (sut, client) = makeSUT()

    expect(sut, toCompleteWith: failure(.invalidData), when: {
      let invalidJSON = Data.init("invalid json".utf8)
      client.complete(withStatusCode: 200, data: invalidJSON)
    })
  }

  func test_load_deliversNoItemsOn200HTTPResponseEmptyJsonList() {
    let (sut, client) = makeSUT()

    expect(sut, toCompleteWith: .success([]), when: {
      let emptyListJSON = Data.init("{\"items\": []}".utf8)
      client.complete(withStatusCode: 200, data: emptyListJSON)
    })
  }

  func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
    let (sut, client) = makeSUT()

    let item1 = makeItem(id: UUID(),
                         imageURL: URL(string: "wwww.a-given-url.com")!)

    let item2 = makeItem(id: UUID(),
                         description: "a description",
                         location: "a location",
                         imageURL: URL(string: "wwww.another-url.com")!)

    let items = [item1.model, item2.model]

    expect(sut, toCompleteWith: .success(items), when: {
      let json = makeItemsJSON([item1.json, item2.json])
      client.complete(withStatusCode: 200, data: json)
    })
  }

  func test_load_doesNotDeliverResultAfterSUTInstaceHasBeenDeallocated() {
    let url = URL(string: "wwww.a-given-url.com")!
    let client = HTTPClientSpy()
    var sut: RemoteFeedLoader? = RemoteFeedLoader(url: url, client: client)
    var capturedResult = [RemoteFeedLoader.Result]()
    sut?.load { capturedResult.append($0) }

    sut = nil
    client.complete(withStatusCode: 200, data: makeItemsJSON([]))
    XCTAssertTrue(capturedResult.isEmpty)
  }

  // MARK: - Helpers
  private func makeSUT(url: URL = URL(string: "wwww.a-given-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
    let client = HTTPClientSpy()
    let sut = RemoteFeedLoader(url: url, client: client)
    trackForMemoryLeaks(sut, file: file, line: line)
    trackForMemoryLeaks(client, file: file, line: line)
    return (sut, client)
  }

  private func failure(_ error: RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
    return .failure(error)
  }

  private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedImage, json: [String: Any]) {
    let item = FeedImage(id: id, description: description, location: location, url: imageURL)
    let itemJson = [
      "id" : id.uuidString,
      "description" : description,
      "location": location,
      "image" : imageURL.absoluteString
    ].compactMapValues( { $0 })
    return (item, itemJson)
  }

  private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
    let json = ["items": items]
    return try! JSONSerialization.data(withJSONObject: json)
  }

  private func expect(_ sut: RemoteFeedLoader, toCompleteWith expectedResult: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {

    let exp = expectation(description: "Wait for load completion")

    sut.load { receivedResult in
      switch (receivedResult, expectedResult) {
      case let (.success(receivedItems), .success(expectedItems)):
        XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)

      case let (.failure(receivedError as RemoteFeedLoader.Error), .failure(expectedError as RemoteFeedLoader.Error)):
        XCTAssertEqual(receivedError, expectedError, file: file, line: line)

      default:
        XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
      }

      exp.fulfill()
    }
    action()

    wait(for: [exp], timeout: 1.0)
  }

  private class HTTPClientSpy: HTTPClient {

    var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()

    var requestUrls: [URL] {
      return messages.map { $0.url}
    }


    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
      messages.append((url, completion))

    }

    func complete(with error: Error, at index: Int = 0) {
      messages[index].completion(.failure(error))
    }

    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
      let response = HTTPURLResponse(
        url: requestUrls[index],
        statusCode: code,
        httpVersion: nil,
        headerFields: nil)!
      messages[index].completion(.success(data, response))
    }
  }

}
