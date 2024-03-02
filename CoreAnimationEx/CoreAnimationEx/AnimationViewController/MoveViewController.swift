//
//  MoveViewController.swift
//  CoreAnimationEx
//
//  Created by jung on 2/29/24.
//

import UIKit
import SnapKit

final class MoveViewController: UIViewController {
	private let animationView: UIView = {
		let view = UIView()
		view.backgroundColor = .red
		
		return view
	}()

	private let animationButton = AnimationButton(text: "Move")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Move Animation"
		self.view.backgroundColor = .white
		
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
		view.addSubview(animationView)
		view.addSubview(animationButton)
		
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
		let animation = CABasicAnimation()
		animation.keyPath = "position.x"
		// 보간해야하기 때문에, from 과 to를 설정해야 한다.
		animation.fromValue = 20 + 140/2
		animation.toValue = 300
		animation.duration = 1
		
		animationView.layer.add(animation, forKey: "Move")
		animationView.layer.position = CGPoint(x: 300, y: 100 + 100/2) // update to final position
	}
}
