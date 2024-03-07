//
//  CATransitionViewController.swift
//  CoreAnimationEx
//
//  Created by jung on 3/7/24.
//

import UIKit
import SnapKit

final class CATransitionViewController: UIViewController {
	// MARK: - UI Components
	private let animationView: UIView = {
		let view = UIView()
		view.backgroundColor = .red
		
		return view
	}()
	
	private let newAnimationView: UIView = {
		let view = UIView()
		view.backgroundColor = .blue
		
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
private extension CATransitionViewController {
	func setupUI() {
		self.title = "CATransition Animaion"
		self.view.backgroundColor = .white
		
		view.addSubview(animationButton)
		view.addSubview(animationView)
		//		view.addSubview(newAnimationView)
		
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
private extension CATransitionViewController {
	
	@objc func didTapButton() {
		let transition = CATransition()
		transition.duration = 0.25
		
		transition.type = .push
		transition.subtype = .fromLeft
		
		animationView.layer.add(transition, forKey: "transition")
		animationView.backgroundColor = .blue
	}
}
