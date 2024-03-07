//
//  NotificationViewContoller.swift
//  CoreAnimationEx
//
//  Created by jung on 3/3/24.
//

import UIKit
import SnapKit

final class NotificationViewContoller: UIViewController {
	// MARK: - UI Compononets
	private let notificatoinView: UIImageView = {
		let image = UIImage(systemName: "bell")
		
		return UIImageView(image: image)
	}()
	
	private let animationButton = AnimationButton(text: "Shake")
	
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
private extension NotificationViewContoller {
	func setupUI() {
		title = "Notification Animation"
		view.backgroundColor = .white
		view.addSubview(notificatoinView)
		view.addSubview(animationButton)
		
		notificatoinView.snp.makeConstraints { make in
			make.center.equalToSuperview()
			make.width.height .equalTo(40)
		}
		
		animationButton.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview().offset(-100)
		}
	}
}

// MARK: - Action Methods
private extension NotificationViewContoller {
	@objc func didTapButton() {
		let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
		animation.values = [-CGFloat.pi/8, CGFloat.pi/8, -CGFloat.pi/8, CGFloat.pi/8, -CGFloat.pi/8, CGFloat.pi/8, 0]
		animation.keyTimes = [0.1667, 0.1667, 0.1667, 0.1667, 0.1667, 0.1667]
		
		animation.duration = 1
		animation.isAdditive = true
		animation.calculationMode = .paced
		
		notificatoinView.layer.add(animation, forKey: "notification")
	}
}
