//
//  FadeAndScaleOutViewController.swift
//  CoreAnimationEx
//
//  Created by jung on 3/7/24.
//

import UIKit
import SnapKit

final class FadeAndScaleOutViewController: UIViewController {
	// MARK: - UI Components
	private let animationView: UIView = {
		let view = UIView()
		view.backgroundColor = .red
		
		return view
	}()
	
	private let animationButton = AnimationButton(text: "Move")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		animationButton.addTarget(
			self,
			action: #selector(didTapButton),
			for: .touchUpInside
		)
	}
}

// MARK: - UI Methods
private extension FadeAndScaleOutViewController {
	func setupUI() {
		self.title = "FadeOut Animaion"
		self.view.backgroundColor = .white
		
		view.addSubview(animationButton)
		view.addSubview(animationView)
		
		animationView.snp.makeConstraints { make in
			make.center.equalToSuperview()
			make.width.equalTo(140)
			make.height.equalTo(100)
		}
		
		animationButton.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview().offset(-100)
		}
	}
}

// MARK: - Action Methods
private extension FadeAndScaleOutViewController {
	@objc func didTapButton() {
		// 1. fadeOut Animation
		let fadeOut = CABasicAnimation(keyPath: "opacity")
		fadeOut.fromValue = 1
		fadeOut.toValue = 0
		fadeOut.duration = 1
		
		// 2. Scale Animation
		let expandScale = CABasicAnimation()
		expandScale.keyPath = "transform.scale"
		expandScale.fromValue = 1
		expandScale.toValue = 3
		
		// 3. Animation Group
		let fadeAndScale = CAAnimationGroup()
		fadeAndScale.animations = [fadeOut, expandScale]
		fadeAndScale.duration = 1
		
		animationView.layer.add(fadeAndScale, forKey: "FadeAndScale")
	}
}
