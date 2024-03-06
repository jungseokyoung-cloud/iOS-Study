//
//  RotateViewController.swift
//  CoreAnimationEx
//
//  Created by jung on 3/3/24.
//

import UIKit
import SnapKit

final class RotateViewController: UIViewController {
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
private extension RotateViewController {
	func setupUI() {
		title = "Rotate Animation"
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
private extension RotateViewController {
	@objc func didTapButton() {
		// 1. Animation 생성
		let animation = CABasicAnimation()
		animation.keyPath = "transform.rotation.z"

		// 2. Animation의 속성 지정
		animation.fromValue = 0
		animation.toValue = CGFloat.pi / 2
		animation.duration = 0.5
		
		// 3. Layer에 animation 추가
		animationView.layer.add(animation, forKey: "Rotate")

		// 4. 최종상태 변경
		animationView.layer.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1)

	}
}
