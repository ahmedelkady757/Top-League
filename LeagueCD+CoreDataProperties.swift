//
//  LeagueCD+CoreDataProperties.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 28/04/2026.
//
//

import Foundation
import CoreData


extension LeagueCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LeagueCD> {
        return NSFetchRequest<LeagueCD>(entityName: "LeagueCD")
    }

    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var id: Int32
    @NSManaged public var sportId: Int32

}

extension LeagueCD : Identifiable {

}
