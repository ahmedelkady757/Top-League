//
//  LeaguesPresnterProtocol.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 02/05/2026.
//

import Foundation

protocol LeaguesPresenterProtocol {
    func fetchLeagues()
    func getListCount()->Int
    func getListItem(index : Int)->League
    func fetchImageData(from urlString: String, completion: @escaping (Data?) -> Void) 
}
