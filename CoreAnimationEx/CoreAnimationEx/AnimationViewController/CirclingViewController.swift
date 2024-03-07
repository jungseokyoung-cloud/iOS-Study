//
//  CirclingViewController.swift
//  CoreAnimationEx
//
//  Created by jung on 3/3/24.
//

import UIKit
import SnapKit

final class CirclingViewController: UIViewController {
	private let diameter = 300
	// MARK: - UI Compononets
	private let animationView: UIView = {
		let view = UIView()
		view.backgroundColor = .red
		
		return view
	}()
	
	private let circularPathView = UIImageView()
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
private extension CirclingViewController {
	func setupUI() {
		title = "Circling Animation"
		view.backgroundColor = .white
		view.addSubview(animationView)
		view.addSubview(circularPathView)
		view.addSubview(animationButton)
		
		animationView.snp.makeConstraints { make in
			make.center.equalToSuperview()
			make.width.height .equalTo(40)
		}
		
		circularPathView.snp.makeConstraints { make in
			make.center.equalToSuperview()
			make.size.equalTo(300)
		}
		
		animationButton.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview().offset(-100)
		}
		
		drawCircularPath()
	}
	
	func drawCircularPath() {
		let size = CGSize(width: diameter, height: diameter)
		let renderer = UIGraphicsImageRenderer(size: size)
		
		let image = renderer.image { context in
			let rectangle = CGRect(origin: .zero, size: size)
			
			context.cgContext.setStrokeColor(UIColor.red.cgColor)
			context.cgContext.setFillColor(UIColor.clear.cgColor)
			context.cgContext.setLineWidth(1)
			context.cgContext.addEllipse(in: rectangle)
			context.cgContext.drawPath(using: .fillStroke)
		}
		
		circularPathView.image = image
	}
}

// MARK: - Action Methods
private extension CirclingViewController {
	@objc func didTapButton() {
		let boundingRect = CGRect(x: -diameter/2, y: -diameter/2, width: diameter, height: diameter)
		
		let animation = CAKeyframeAnimation()
		animation.keyPath = "position"
		
		// 1. 경로 설정
		animation.path = CGPath(ellipseIn: boundingRect, transform: nil)
		animation.duration = 2
		
		// 2. boundingRect을 상대값으로 x,y좌표를 잡았기 때문에 true로 설정
		animation.isAdditive = true
		
		// 3. keyFrame간에 어떻게 Interpolation할지 결정한다.
		animation.calculationMode = .paced
		animationView.layer.add(animation, forKey: "Shake")
	}
}
