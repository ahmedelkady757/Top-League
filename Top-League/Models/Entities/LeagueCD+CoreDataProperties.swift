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

}

extension LeagueCD : Identifiable {

}
