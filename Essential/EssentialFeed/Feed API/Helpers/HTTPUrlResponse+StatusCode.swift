//
//  HTTPUrlResponse+StatusCode.swift
//  EssentialFeed
//
//  Created by Ilhan Sari on 20.03.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
