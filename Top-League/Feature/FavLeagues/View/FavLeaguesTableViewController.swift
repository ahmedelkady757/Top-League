//
//  LeaguesTableViewController.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 30/04/2026.
//

import UIKit

class FavLeaguesTableViewController: UITableViewController {
    var presenter : FavLeaguesPresenterProtocol!
    var indecator = UIActivityIndicatorView(style: .large)
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "LeaguesTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LeaguesTableViewCell")
        presenter = FavLeaguesPresenter(view: self)
        presenter.getLeaguesList()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getListCount()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaguesTableViewCell", for: indexPath) as! LeaguesTableViewCell

        let league = presenter.getListItem(index: indexPath.row)
        cell.config(name: league.name!, image: league.image!)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteItem(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }    
    }
}
extension FavLeaguesTableViewController: FavleaguesView {
    
    func listIsEmpty() {
        let emptyImage = UIImage(named: "empty_favorites")
        let imageView = UIImageView(image: emptyImage)
                
        imageView.contentMode = .center
                
        self.tableView.backgroundView = imageView
        self.tableView.separatorStyle = .none
    }
    
    func realoadList() {
        self.tableView.backgroundView = nil
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = UIColor(named: "PrimaryColor")
        tableView.reloadData()
    }

    func isLoading() {
        indecator.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        indecator.color = UIColor(named: "PrimaryColor")
        indecator.startAnimating()
        view.addSubview(indecator)
    }
    
    func hideLoading() {
        indecator.stopAnimating()
        indecator.removeFromSuperview()
    }
}
