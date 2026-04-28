//
//  CoreDataManager.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 28/04/2026.
//

import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveLeague(id: Int,name: String, image : Data, sportId: Int) {
        if isLeagueSaved(id: id) { return }
        
        let entity = LeagueCD(context: context)
        entity.id = Int32(id)
        entity.name = name
        entity.image = image
        entity.sportId = Int32(sportId)
        
        saveContext()
    }
    
    func deleteLeague(id: Int) {
        let request: NSFetchRequest<LeagueCD> = LeagueCD.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        
        if let result = try? context.fetch(request),
           let entity = result.first {
            context.delete(entity)
            saveContext()
        }
    }
    
    func fetchFavoriteLeagues() -> [LeagueCD] {
        let request: NSFetchRequest<LeagueCD> = LeagueCD.fetchRequest()
        return (try? context.fetch(request)) ?? []
    }
    
    func isLeagueSaved(id: Int) -> Bool {
        let request: NSFetchRequest<LeagueCD> = LeagueCD.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        let count = (try? context.count(for: request)) ?? 0
        return count > 0
    }
    
    private func saveContext() {
        if context.hasChanges {
            try? context.save()
        }
    }
}
