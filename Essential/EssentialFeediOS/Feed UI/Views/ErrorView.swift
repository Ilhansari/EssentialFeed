//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import UIKit

public final class ErrorView: UIView {
	@IBOutlet private(set) public var button: UIButton!
	
	public var message: String? {
		get { isVisible ? button.title(for: .normal) : nil }
		set { newValue.map(showAnimated) ?? hideMessage() }
	}
	
	private var isVisible: Bool {
		return alpha > 0
	}
	
	public override func awakeFromNib() {
		super.awakeFromNib()
		
		button.setTitle(nil, for: .normal)
		button.titleLabel?.textColor = .white
		button.titleLabel?.textAlignment = .center
		button.titleLabel?.numberOfLines = 0
		button.titleLabel?.adjustsFontForContentSizeCategory = true
		
		hideMessage()
	}
	
	private func showAnimated(message: String) {
		button.setTitle(message, for: .normal)
		button.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)

		UIView.animate(withDuration: 0.25) {
			self.alpha = 1
		}
	}
	
	@IBAction func hideMessageAnimated() {
		UIView.animate(
			withDuration: 0.25,
			animations: { self.alpha = 0 },
			completion: { completed in
				if completed { self.hideMessage() }
			})
	}
	
	private func hideMessage() {
		button.setTitle(nil, for: .normal)
		button.contentEdgeInsets = .init(top: -2.5, left: 0, bottom: -2.5, right: 0)
		alpha = 0
	}
}
