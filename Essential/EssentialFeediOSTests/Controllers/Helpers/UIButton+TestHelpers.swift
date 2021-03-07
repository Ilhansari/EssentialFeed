//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Ilhan Sari on 27.02.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
