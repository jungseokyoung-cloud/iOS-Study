//
//  ScaleViewController.swift
//  CoreAnimationEx
//
//  Created by jung on 2/29/24.
//

import UIKit
import SnapKit

final class ScaleViewController: UIViewController {
	private let animationView: UIView = {
		let view = UIView()
		view.backgroundColor = .red
		
		return view
	}()

	private let animationButton = AnimationButton(text: "Scale")
	
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
private extension ScaleViewController {
	func setupUI() {
		title = "Scale Animation"
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
private extension ScaleViewController {
	@objc func didTapButton() {
		// 1. Animation 생성
		let animation = CABasicAnimation()
		animation.keyPath = "transform.scale"

		// 2. Animation의 속성 지정
		animation.fromValue = 1
		animation.toValue = 2
		animation.duration = 0.5
		
		// 3. Layer에 animation 추가
		animationView.layer.add(animation, forKey: "Scale")
		
		// 4. 최종상태 변경
		animationView.layer.transform = CATransform3DMakeScale(2, 2, 1)
	}
}
