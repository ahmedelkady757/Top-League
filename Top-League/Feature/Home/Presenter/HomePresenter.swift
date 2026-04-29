//
//  Hom.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 29/04/2026.
//

class HomePresenter{
    let collectionList :[String] = ["Football","Basketball","Cricket","Tennis"]
    func getCollectionItem(index: Int) -> String {
        return collectionList[index]
    }
}
