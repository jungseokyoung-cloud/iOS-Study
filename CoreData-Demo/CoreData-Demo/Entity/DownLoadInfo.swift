//
//  ImageList.swift
//  CoreData-Demo
//
//  Created by jung on 10/6/23.
//

import Foundation

struct DownLoadInfo: Decodable {
	let id: String
	let author: String
	let downloadURL: String
	
	enum CodingKeys: String, CodingKey {
		case id
		case author
		case downloadURL = "download_url"
	}
}
