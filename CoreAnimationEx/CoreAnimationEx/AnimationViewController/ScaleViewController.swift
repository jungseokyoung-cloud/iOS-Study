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
		view.addSubview(animationView)
		view.addSubview(animationButton)
		
		animationView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(20)
			make.top.equalToSuperview().offset(100)
			make.width.equalTo(140)
			make.height.equalTo(100)
		}
	}
}

// MARK: - Action Methods
private extension ScaleViewController {
	@objc func didTapButton() { }
}
