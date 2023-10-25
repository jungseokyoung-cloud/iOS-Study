//
//  Photo+CoreDataProperties.swift
//  CoreData-Demo
//
//  Created by Seok Young Jung on 2023/10/22.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var author: String?
    @NSManaged public var id: Int64
    @NSManaged public var image: Data?

}

extension Photo : Identifiable {

}
