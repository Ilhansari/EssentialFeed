//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Ilhan Sari on 6.03.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
