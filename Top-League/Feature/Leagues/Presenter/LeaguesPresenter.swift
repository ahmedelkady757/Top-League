//
//  LeaguesPresnter.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 02/05/2026.
//

import Foundation
import UIKit

class LeaguesPresenter : LeaguesPresenterProtocol{
    var sportIndex: Int!
    weak var view: LeaguesView!
    var networkManager: NetworkService!
    var leagues: [League] = []
    
    init(index: Int, view: LeaguesView,){
        sportIndex = index
        self.view = view
    }
    func fetchLeagues() {
        view?.isLoading()
        
        let selectedSport: SportType = getSportType(from: sportIndex)
         networkManager = AlamofireNetworkService.shared
        networkManager.fetchLeagues(sport: selectedSport) { [weak self] (fetchedLeagues, error) in
            Task { @MainActor in
                guard let self = self else { return }
                                
                if let error = error {
                    print("Error fetching leagues: \(error.localizedDescription)")
                    return
                }
                
                if let result = fetchedLeagues {
                    self.leagues = result
                    if result.isEmpty {
                        self.view.listIsEmpty()
                    } else {
                        self.view.realoadList()
                    }
                    self.view.hideLoading()

                }
            }
        }
    }
    func fetchImageData(from urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                    completion(nil)
                    return
                }
                
                await MainActor.run {
                    completion(data)
                }
            } catch {
                print("Failed to load image: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    func getListCount() -> Int {
        return leagues.count
    }
    
    func getListItem(index: Int) -> League{
        return leagues[index]
    }

    private func getSportType(from index: Int) -> SportType {
        switch index {
        case 0: return .football
        case 1: return .basketball
        case 2: return .cricket
        default: return .tennis
        }
    }
}
