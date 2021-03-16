//
//  UIImageView+Animations.swift
//  EssentialFeediOS
//
//  Created by Ilhan Sari on 6.03.2021.
//  Copyright © 2021 ilhan sarı. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImageAnimated(_ newImage: UIImage?) {
        image = newImage
        
        guard newImage != nil else { return }
        
        alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}
