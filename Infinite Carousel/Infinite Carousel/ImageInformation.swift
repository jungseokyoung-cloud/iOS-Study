//
//  ImageDTO.swift
//  Infinite Carousel
//
//  Created by Seok Young Jung on 2023/07/22.
//

import Foundation

struct ImageInformation: Decodable {
	let id: String
	let author: String
	let downloadURL: String
	
	enum CodingKeys: String, CodingKey {
		case id
		case author
		case downloadURL = "download_url"
	}
}
