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
		
		attributesList = (0..<collectionView.numberOfItems(inSection: 0)).map { index -> CircularCollectionViewLayoutAttributes in
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
			attributes.angle = self.anglePerItem*CGFloat(index)
			return attributes
		}
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		return attributesList
	}
	
	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return attributesList[indexPath.row]
	}
}
