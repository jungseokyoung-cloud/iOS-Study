//
//  DropDownCell.swift
//  CustomDropDown
//
//  Created by jung on 10/29/23.
//

import UIKit
import SnapKit

final class DropDownCell: UITableViewCell {
	static let identifier = "Cell"
	
	override var isSelected: Bool {
		didSet {
			optionLabel.textColor = isSelected ? .black : .systemGray2
		}
	}
	
	// MARK: - UI Components
	private let optionLabel: UILabel = {
		let label = UILabel()
		
		return label
	}()
	
	// MARK: - Initializers
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.selectionStyle = .none
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	// MARK: - Configure
	func configure(with text: String) {
		optionLabel.text = text
	}
}

// MARK: - UI Methods
private extension DropDownCell {
	func setupUI() {
		setViewHierarchy()
		setConstraints()
	}
	
	func setViewHierarchy() {
		contentView.addSubview(optionLabel)
	}
	
	func setConstraints() {
		optionLabel.snp.makeConstraints { make in
			make.leading.top.equalToSuperview().offset(8)
			make.bottom.equalToSuperview().offset(-8)
		}
	}
}
