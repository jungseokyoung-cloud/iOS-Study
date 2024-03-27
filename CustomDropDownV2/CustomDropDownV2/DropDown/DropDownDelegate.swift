//
//  DropDownDelegate.swift
//  CustomDropDownV2
//
//  Created by jung on 3/26/24.
//

import UIKit

protocol DropDownDelegate: AnyObject {
	func dropDown(_ dropDownView: DropDownView, didSelectRowAt indexPath: IndexPath)
}
