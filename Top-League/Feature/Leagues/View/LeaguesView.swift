//
//  LeaguesView.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 02/05/2026.
//

protocol LeaguesView : AnyObject{
    func isLoading()
    func hideLoading()
    func listIsEmpty()
    func realoadList()
}
