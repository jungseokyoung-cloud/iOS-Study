//
//  ImageRepository.swift
//  Infinite Carousel
//
//  Created by Seok Young Jung on 2023/07/22.
//

import UIKit
import RxSwift

protocol ImageRepositoryType {
	func fetchImages(_ imageCount: Int) async -> Single<[UIImage?]>
}

struct ImageRepository: ImageRepositoryType {
	private let imageListURL = "https://picsum.photos/v2/list?page=5&limit="
	
	/// fetch from URL and return Data
	func fetch(_ url: URL) async throws -> Data {
		let request = URLRequest(url: url)
		let (data, response) = try await URLSession.shared.data(for: request)
		
		guard
			let statusCode = (response as? HTTPURLResponse)?.statusCode,
			(200...299).contains(statusCode)
		else {
			throw NSError(domain: "fetch error", code: 1004)
		}
		
		return data
	}
	
	/// fetch images from image url list
	func fetchImagesFromURLs(_ imageCount: Int) async throws -> [UIImage?] {
		let listURL = getURL(imageCount)
		
		let informationsData = try await fetch(listURL)
		let informations = try JSONDecoder().decode(
			[ImageInformation].self,
			from: informationsData
		)
		
		let imagesData = try await informations
			.map { URL(string: $0.downloadURL)! }
			.asyncMap {
				try await fetch($0)
			}
		
		return imagesData.map { UIImage(data: $0) }
	}
	
	/// return images to Single
	func fetchImages(_ imageCount: Int) async -> Single<[UIImage?]> {
		do {
			let images = try await fetchImagesFromURLs(imageCount)
			
			return Single.create { emitter in
				emitter(.success(images))
				
				return Disposables.create()
			}
			
		} catch {
			return Single.create { emitter in
				emitter(.failure(error))
				
				return Disposables.create()
			}
		}
	}
	
	func getURL(_ imageCount: Int) -> URL {
		return URL(string: "\(imageListURL)\(imageCount)")!
	}
}
