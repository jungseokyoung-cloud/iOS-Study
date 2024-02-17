//
//  CircularCollectionViewLayout.swift
//  Spinning Wheel
//
//  Created by jung on 2/17/24.
//

import UIKit

final class CircularCollectionViewLayout: UICollectionViewLayout {
	/// item의 Size를 정의한다. 여기서는 Cell의 Size
	let itemSize = CGSize(width: 133, height: 173)
	
	/// 반지름을 정의한다. 변경될 때마다, Layout을 재계산한다.
	var radius: CGFloat = 500 {
		didSet { invalidateLayout() }
	}
	
	/// Cell 사이 각도를 정의한다.
	var anglePerItem: CGFloat {
		return atan(itemSize.width / radius)
	}
	
	/// `CollectionView`에서  최대 각도를 정의한다.
	var angleAtExtreme: CGFloat {
		guard let collectionView else { return .zero }
		
		let itemCount = collectionView.numberOfItems(inSection: 0)
		
		return itemCount > 0 ? -CGFloat(itemCount - 1) * anglePerItem : 0
	}
	
	/// 현재 `CollectionView`의 각도를 정의한다.
	var angle: CGFloat {
		guard let collectionView else { return .zero }
		
		return angleAtExtreme * collectionView.contentOffset.x / (collectionViewContentSize.width -
			CGRectGetWidth(collectionView.bounds))
	}
	
	/// LayoutAttributes를 캐싱하기 위한 프로퍼티
	var attributesList = [CircularCollectionViewLayoutAttributes]()
	
	override var collectionViewContentSize: CGSize {
		guard let collectionView else { return .zero }
		
		// ContentSize는 width의 경우 itemSize * item 수
		// height는 CollectionView와 동일하도록 설정한다.
		return CGSize(
			width: itemSize.width * CGFloat(collectionView.numberOfItems(inSection: 0)),
			height: CGRectGetHeight(collectionView.bounds)
		)
	}
	
	// 이제 LayoutAttribute가 UICollectionViewLayoutAttributes가 아닌, CircularLayoutAttributes이라고 명시하는 거
	override class var layoutAttributesClass: AnyClass {
		return CircularCollectionViewLayoutAttributes.self
	}
	
	override func prepare() {
		super.prepare()
		
		guard let collectionView else { return }
		
		// CollectionView에서 center에 위치한 offset
		let centerX = collectionView.contentOffset.x + (CGRectGetWidth(collectionView.bounds) / 2.0)
		
		// anchorPoint는 0~1의 값을 갖기 때문에 scaling을 해준다.
		let anchorPointY = ((itemSize.height / 2.0) + radius) / itemSize.height
		
		let (startIndex, endIndex) = visibleIndexRange()
		
		attributesList = (startIndex...endIndex).map { index -> CircularCollectionViewLayoutAttributes in
			let indexPath = IndexPath(row: index, section: 0)
			let attributes = CircularCollectionViewLayoutAttributes(forCellWith: indexPath)
			attributes.size = self.itemSize
			
			// 우선 모든 Cell들을 가장 중앙으로
			attributes.center = CGPoint(
				x: centerX,
				y: CGRectGetMidY(collectionView.bounds)
			)
			
			// anchorPoint를 지정
			attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)

			// 여기서 각도만 변경!
			attributes.angle = self.angle + (self.anglePerItem * CGFloat(index))
			
			return attributes
		}
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		return attributesList
	}
	
	// Scroll할때 Layout재계산하도록 한다.
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}
}

// MARK: - Private Method
private extension CircularCollectionViewLayout {
	/// 화면에 보이는 Cell의 Index범위를 리턴합니다.
	func visibleIndexRange() -> (startIndex: Int, endIndex: Int) {
		guard let collectionView else { return (0, 0) }

		let theta = atan2(CGRectGetWidth(collectionView.bounds) / 2.0,
											radius + (itemSize.height / 2.0) - (CGRectGetHeight(collectionView.bounds) / 2.0))

		var startIndex = 0
		var endIndex = collectionView.numberOfItems(inSection: 0) - 1

		if (angle < -theta) {
			startIndex = Int(floor((-theta - angle) / anglePerItem))
		}

		endIndex = min(endIndex, Int(ceil((theta - angle) / anglePerItem)))

		if (endIndex < startIndex) {
			endIndex = 0
			startIndex = 0
		}
		
		return (startIndex, endIndex)
	}
}
