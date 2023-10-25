//
//  Repository.swift
//  CoreData-Demo
//
//  Created by jung on 10/5/23.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa

enum FetchType {
	/// 항상 서버에서 가져옵니다.
	case server

	/// 만약 코어데이터에 데이터가 있다면, 코어 데이터에서 가져옵니다.
	/// 없다면 서버에서 가져옵니다.
	case coreData
}

protocol RepositoryType {
	var fetchType: FetchType { get set }
	
	func fetchImages(from: FetchType) async -> Single<[ImageInfo]>
	
	func storeCoreData(for images: [ImageInfo])
	func fetchFromCoreData() async -> [ImageInfo]
	func deleteCoreData(for id: Int)
	func updateCoreData(from id: Int, to info: ImageInfo)
}

struct Repository: RepositoryType {
	// MARK: - Properties
	private let url = "https://picsum.photos/v2/list?page=2&limit=5"
	private let persistentManager = PersistenceManager()
	
	var fetchType: FetchType = .coreData
	
	// MARK: - Methods
	func fetchImages(from fetchType: FetchType) async -> Single<[ImageInfo]> {
		switch fetchType {
			case .server:
				return await createSingle(data: fetchFromServer())

			case .coreData:
				return await createSingle(data: fetchFromCoreData())
		}
	}
}

// MARK: - Fetch From Server
private extension Repository {
	func fetchFromServer() async -> [ImageInfo] {
		do {
			let downLoadInfo: [DownLoadInfo] = try await fetch(with: URL(string: url)!)
			var imageInfo: [ImageInfo] = []
			
			try await downLoadInfo.asyncForEach { info in
				let image = try await fetchImage(with: URL(string: info.downloadURL)!)
				
				imageInfo.append(convertToImageInfo(from: info, image: image))
			}
			
			storeCoreData(for: imageInfo)
			return imageInfo
			
		} catch {
			fatalError()
		}
	}
}

// MARK: - Read From Core Data
extension Repository {
	/// Read
	func fetchFromCoreData() async -> [ImageInfo] {
		if
			let managedObjects = persistentManager.read(),
			!managedObjects.isEmpty {
			return managedObjects.map { convertToImageInfo(from: $0) ?? .defaultInfo }
		} else {
			let imageInfo = await fetchFromServer()
			storeCoreData(for: imageInfo)
			return imageInfo
		}
	}
	
	/// Create
	func storeCoreData(for images: [ImageInfo]) {
		delectedAllCoreData()
		images.forEach { persistentManager.createPhoto($0) }
	}
	
	/// Update
	func updateCoreData(from id: Int, to info: ImageInfo) {
		guard
			fetchType == .coreData,
			let managedObject = persistentManager.read(at: id),
			let imageData = info.image.pngData()
		else { return }
		
		managedObject.setValue(info.id, forKey: "id")
		managedObject.setValue(info.author, forKey: "author")
		managedObject.setValue(imageData, forKey: "image")
		
		persistentManager.save()
	}
	
	func deleteCoreData(for id: Int) {
		guard
			fetchType == .coreData,
			let managedObject = persistentManager.read(at: id)
		else { return }

		persistentManager.context.delete(managedObject)
		persistentManager.save()
	}
	
	func delectedAllCoreData() {
		guard let managedObjects = persistentManager.read() else { return }
		
		managedObjects.forEach { persistentManager.context.delete($0) }
		persistentManager.save()
	}
}


// MARK: - Private Method
private extension Repository {
	func fetch<T: Decodable>(with url: URL) async throws -> T {
		let (data, _) = try await URLSession.shared.data(from: url)
		
		return try JSONDecoder().decode(T.self, from: data)
	}
	
	func fetchImage(with url: URL) async throws -> UIImage {
		let (data, _) = try await URLSession.shared.data(from: url)
		
		guard let image = UIImage(data: data) else { throw FetchError.fetchError }
		
		return image
	}
	
	func createSingle<T>(data: T) -> Single<T> {
		return Single<T>.create { emitter in
			emitter(.success(data))
			
			return Disposables.create()
		}
	}
	
	func convertToImageInfoList(from managedObjects: [NSManagedObject]) -> [ImageInfo] {
		return managedObjects.compactMap { convertToImageInfo(from: $0) }
	}
	
	func convertToImageInfo(from managedObject: NSManagedObject) -> ImageInfo? {
		guard
			let id = managedObject.value(forKey: "id") as? Int,
			let author = managedObject.value(forKey: "author") as? String,
			let imageData = managedObject.value(forKey: "image") as? Data,
			let image = UIImage(data: imageData)
		else {
			return nil
		}
		return ImageInfo(id: id, author: author, image: image)
	}
	
	func convertToImageInfo(from info: DownLoadInfo, image: UIImage) -> ImageInfo {
		return ImageInfo(
			id: Int(info.id) ?? 0,
			author: info.author,
			image: image
		)
	}
}
