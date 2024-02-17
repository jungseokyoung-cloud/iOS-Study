//
//  CircularCollectionViewLayoutAttributes.swift
//  Spinning Wheel
//
//  Created by jung on 2/17/24.
//

import UIKit

final class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
	/// Cell의 AnchorPoint를 정의 한다 (회천축)
	var anchorPoint = CGPoint(x: 0.5, y: 0.5)
	/// Cell의 각도 (0번 cell을 기준으로 각도를 정의한다.)
	var angle: CGFloat = 0 {
		didSet {
			// 각 cell들이 overlap될 수 있도록, z축을 설정한다.
			zIndex = Int(angle * 1000000)
			// angle이 변할 때, 각 Cell에 transform을 적용한다.
			transform = CGAffineTransformMakeRotation(angle)
		}
	}
	
	// Default로 LayoutAttribute객체는 NSCopying을 만족함!
	// 그래서 Custom한 경우, 복사할 때 커스텀 프로퍼티를 직접 전달해주어야 함.
	override func copy(with zone: NSZone? = nil) -> Any {
		let copiedAttributes = super.copy(with: zone)
		
		guard let copiedCircularAttributes : CircularCollectionViewLayoutAttributes = copiedAttributes as? CircularCollectionViewLayoutAttributes else {
			return copiedAttributes
		}
		
		copiedCircularAttributes.anchorPoint = self.anchorPoint
		copiedCircularAttributes.angle = self.angle
		return copiedCircularAttributes
	}
}
