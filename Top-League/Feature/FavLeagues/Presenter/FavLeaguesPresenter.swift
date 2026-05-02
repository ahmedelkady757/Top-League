//
//  FavLeaguesPresenter.swift
//  Top-League
//
//  Created by Sherry Ahmos on 30/04/2026.
//

import UIKit

class FavLeaguesPresenter : FavLeaguesPresenterProtocol{
    var favLeaguesList : [LeagueCD] = []
    let view : FavleaguesView!
    let cdManager = CoreDataManager.shared
    
    init(view: FavleaguesView!) {
        self.view = view
    }
    func getLeaguesList(){
        view.isLoading()
        if let image = UIImage(named: "Football"),
           let imageData = image.pngData() {
            cdManager.saveLeague(
                id: 1,
                name: "Premier League",
                image: imageData,
                sportId: 1
            )
        }
        favLeaguesList = cdManager.fetchFavoriteLeagues()
        print(favLeaguesList.count)
        view.hideLoading()
        if(favLeaguesList.isEmpty){
            view.listIsEmpty()
        }else{
            view.realoadList()
        }
    }
    func getListCount()->Int{
        return favLeaguesList.count
    }
    func getListItem(index : Int)->LeagueCD{
        return favLeaguesList[index]
    }
    func deleteItem(index: Int) {
        let itemToDelete = favLeaguesList[index]
        
        cdManager.deleteLeague(id: Int(itemToDelete.id))
        
        favLeaguesList.remove(at: index)
        
        if favLeaguesList.isEmpty {
            view.listIsEmpty()
        }
    }
}
