//
//  CircularCollectionViewCell.swift
//  Spinning Wheel
//
//  Created by jung on 2/17/24.
//

import UIKit
import SnapKit

final class CircularCollectionViewCell: UICollectionViewCell {
	// MARK: - UI Components
	private let label = UILabel()
	
	// MARK: - Initazliers
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Apply Method
	override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
		super.apply(layoutAttributes)
		
		guard let circularLayoutAttributes = layoutAttributes as? CircularCollectionViewLayoutAttributes else { return }
		
		self.layer.anchorPoint = circularLayoutAttributes.anchorPoint
		self.center.y += (circularLayoutAttributes.anchorPoint.y - 0.5) * CGRectGetHeight(self.bounds)
	}
	
	// MARK: - Configure Method
	func configure(with viewModel: CircularViewModel) {
		self.backgroundColor = viewModel.color
		self.label.text = viewModel.text
	}
}

// MARK: - UI Setting
private extension CircularCollectionViewCell {
	func setupUI() {
		contentView.addSubview(label)
		label.snp.makeConstraints { $0.center.equalToSuperview() }
	}
}
