//
//  AnimationButton.swift
//  CoreAnimationEx
//
//  Created by jung on 2/29/24.
//

import UIKit

final class AnimationButton: UIButton {
	// MARK: - Initializers
	init(text: String) {
		super.init(frame: .zero)
		self.setTitle(text, for: .normal)
		self.backgroundColor = .blue
		self.layer.cornerRadius = 8
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
