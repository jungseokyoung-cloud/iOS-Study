//
//  PersistenceManager.swift
//  CoreData-Demo
//
//  Created by jung on 10/6/23.
//

import UIKit
import CoreData

final class PersistenceManager {
	// MARK: - Enum
	enum StorageType {
		case sqlite
		case binary
		case inMemory
	}
	
	// MARK: - Properties
	private let storageType: StorageType = .sqlite
	
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Model")
		
		if self.storageType != .sqlite {
			let description = NSPersistentStoreDescription()
			description.type = convertNSStoreType()
			container.persistentStoreDescriptions = [description]
		}
		
		container.loadPersistentStores { storeDesciption, error in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
		
		return container
	}()
	
	var context: NSManagedObjectContext {
		return self.persistentContainer.viewContext
	}
}

// MARK: - Private Methods
private extension PersistenceManager {
	/// StorageType에서 NSStoreType으로 변환
	func convertNSStoreType() -> String {
		switch storageType {
		case .sqlite:
			return NSSQLiteStoreType
		case .binary:
			return NSBinaryStoreType
		case .inMemory:
			return NSInMemoryStoreType
		}
	}
}

// MARK: - Methods
extension PersistenceManager {
	@discardableResult
	
	func save() -> Bool {
		guard context.hasChanges else { return false }
		
		do {
			try self.context.save()
			return true
		} catch {
			print(error.localizedDescription)
			return false
		}
	}
	
	@discardableResult
	func createPhoto(_ info: ImageInfo) -> Bool {
		let photo = Photo(context: context)
		
		photo.id = Int64(info.id)
		photo.author = info.author
		photo.image = info.image.pngData()
		
		return save()
	}
	
	func read() -> [NSManagedObject]? {
		let readRequest = NSFetchRequest<NSManagedObject>(entityName: "Photo")
		
		return try? context.fetch(readRequest)
	}
	
	func read(at id: Int) -> NSManagedObject? {
		guard let imageInfoData = read() else { return nil }
		
		return imageInfoData
			.filter { ($0.value(forKey: "id") as? Int) == id }
			.first
	}
}
