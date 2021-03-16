//
//  UIControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Ilhan Sari on 27.02.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
