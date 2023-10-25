//
//  ImageViewCell.swift
//  CoreData-Demo
//
//  Created by jung on 10/5/23.
//

import UIKit
import SnapKit

final class ImageViewCell: UITableViewCell {
	static let identifier = "ImageViewCell"
	
	// MARK: - UI Components
	private let profileImageView = UIImageView()
	
	private let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.distribution = .fillEqually
		
		return stackView
	}()
	
	private let authorLabel = UILabel()
	private let idLabel = UILabel()
	
	// MARK: - Initializer
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		setupUI()
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	// MARK: - Configure
	func configure(with info: ImageInfo) {
		profileImageView.image = info.image
		profileImageView.contentMode = .scaleAspectFit
		
		authorLabel.text = info.author
		idLabel.text = "\(info.id)"
	}
}

// MARK: - UI Methods
private extension ImageViewCell {
	func setupUI() {
		setViewHierarchy()
		setConstraints()
	}
	
	func setViewHierarchy() {
		contentView.addSubview(profileImageView)
		contentView.addSubview(stackView)
		stackView.addArrangedSubview(authorLabel)
		stackView.addArrangedSubview(idLabel)
	}
	
	func setConstraints() {
		profileImageView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(20)
			make.height.width.equalTo(100)
			make.top.equalToSuperview().offset(10)
		}
		
		stackView.snp.makeConstraints { make in
			make.leading.equalTo(profileImageView.snp.trailing).offset(20)
			make.centerY.equalToSuperview()
		}
	}
}
