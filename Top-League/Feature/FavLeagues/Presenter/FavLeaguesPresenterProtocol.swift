//
//  FavLeaguesPresenterProtocol.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 02/05/2026.
//


protocol FavLeaguesPresenterProtocol{
    func getLeaguesList()
    func getListCount()->Int
    func getListItem(index : Int)->LeagueCD
    func deleteItem(index: Int)
}
