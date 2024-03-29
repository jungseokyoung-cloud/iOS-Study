//
//  MoveViewController.swift
//  CoreAnimationEx
//
//  Created by jung on 2/29/24.
//

import UIKit
import SnapKit

final class MoveViewController: UIViewController {
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
private extension MoveViewController {
	func setupUI() {
		self.title = "Move Animation"
		self.view.backgroundColor = .white

		view.addSubview(animationButton)
		view.addSubview(animationView)
		
		animationView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(20)
			make.top.equalToSuperview().offset(100)
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
private extension MoveViewController {
	@objc func didTapButton() {
		// 1. Animation 생성
		let animation = CABasicAnimation()
		animation.keyPath = "position.x"
		
		// 2. Animation의 속성 지정
		animation.beginTime = CACurrentMediaTime() + 0.8
		animation.fromValue = 20 + 140/2
		animation.toValue = 300
		animation.duration = 0.5
		
		// 3. Layer에 animation 추가
		animationView.layer.add(animation, forKey: "Move")
		
		// 4. 최종위치 변경
		animationView.layer.position = CGPoint(x: 300, y: 100 + 100/2)
	}
}
