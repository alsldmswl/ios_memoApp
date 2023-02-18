//
//  MemoEntity+CoreDataProperties.swift
//  memoApp
//
//  Created by eun-ji on 2023/02/12.
//
//

import Foundation
import CoreData


extension MemoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoEntity> {
        return NSFetchRequest<MemoEntity>(entityName: "MemoEntity")
    }

    @NSManaged public var contents: String?
    @NSManaged public var date: Date?

}

extension MemoEntity : Identifiable {

}
