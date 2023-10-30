//
//  DropDownListener.swift
//  CustomDropDown
//
//  Created by jung on 10/30/23.
//

import UIKit

protocol DropDownListener: AnyObject {
	var dropDownViews: [DropDownView]? { get set }
	
	func hit(at hitView: UIView?)
	func registerDropDrownViews(_ dropDownViews: DropDownView...)
	func dropdown(_ dropDown: DropDownView, didSelectRowAt indexPath: IndexPath)
}

extension DropDownListener where Self: UIViewController {
	func registerDropDrownViews(_ dropDownViews: DropDownView...) {
		self.dropDownViews = dropDownViews
		dropDownViews.forEach {
			$0.listener = self
			$0.anchorView?.isUserInteractionEnabled = true
		}
	}
	
	func hit(at hitView: UIView?) {
		guard let hitView = hitView else { return }
		
		dropDownViews?.forEach { view in
			if
				view.anchorView === hitView {
				view.isDisplayed.toggle()
			} else {
				view.isDisplayed = false
			}
		}
	}
}

