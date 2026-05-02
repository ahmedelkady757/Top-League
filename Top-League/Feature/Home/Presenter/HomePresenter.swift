//
//  Hom.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 29/04/2026.
//

class HomePresenter: HomePresnterProtocol{
    let collectionList :[String] = ["Football","basketball","Cricket","tennis"]
    func getCollectionItem(index: Int) -> String {
        return collectionList[index]
    }
}
