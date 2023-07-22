//
//  TabBarButton.swift
//  CustomTabBar
//
//  Created by Seok Young Jung on 2023/07/22.
//

import UIKit

final class TabBarButton: UIButton {
	 var buttonIsSelected: Bool = false {
		didSet {
			if buttonIsSelected == true {
				setTitleFont(.boldSystemFont(ofSize: 14))
			} else {
				setTitleFont(.systemFont(ofSize: 12))
			}
		}
	}
	
	init(title: String, image: UIImage?) {
		super.init(frame: .zero)
		
		var configuration = UIButton.Configuration.plain()
		configuration.image = image
		configuration.imagePadding = 4 // 사이 간격
		configuration.imagePlacement = .top // 이미지 위치
		var titleAttribute = AttributedString.init(title)
		titleAttribute.font = .systemFont(ofSize: 12)
		configuration.attributedTitle = titleAttribute
		
		self.configuration = configuration
		self.titleLabel?.tintColor = .black
		self.tintColor = .black
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	func setTitleFont(_ font: UIFont?) {
		configuration?.attributedTitle?.font = font
	}
}
