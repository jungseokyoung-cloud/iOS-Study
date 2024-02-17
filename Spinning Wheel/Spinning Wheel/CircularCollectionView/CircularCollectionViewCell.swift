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
