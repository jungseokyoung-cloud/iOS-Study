//
//  ImageInfo.swift
//  CoreData-Demo
//
//  Created by jung on 10/6/23.
//

import UIKit

struct ImageInfo {
	let id: Int
	let author: String
	let image: UIImage
}

extension ImageInfo {
	static let defaultInfo = ImageInfo(id: 0, author: "", image: UIImage())
}
