//
//  ShakingViewController.swift
//  CoreAnimationEx
//
//  Created by jung on 3/3/24.
//

import UIKit
import SnapKit

final class ShakeViewController: UIViewController {
	private let animationView: UIView = {
		let view = UIView()
		view.backgroundColor = .red
		
		return view
	}()

	private let animationButton = AnimationButton(text: "Rotate")
	
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
private extension ShakeViewController {
	func setupUI() {
		title = "Shake Animation"
		view.backgroundColor = .white
		view.addSubview(animationView)
		view.addSubview(animationButton)
		
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
private extension ShakeViewController {
	@objc func didTapButton() {
		// 1. Animation 생성
		let animation = CAKeyframeAnimation()
		animation.keyPath = "position.x"

		// 2. keyFrame에서의 layer 속성 값들을 기입
		animation.values = [0, 10, -10, 10, 0]
		// 3. 각 keyFrame에서의 시간을 지정 (0~1사이 값을 가진다.)
		animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
		animation.duration = 0.5
		
		// 4. 현재 속성값을 기준으로 values가 계산됨
		animation.isAdditive = true
		animationView.layer.add(animation, forKey: "Shake")
	}
}
