//
//  LeaguesTableViewController.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 30/04/2026.
//

import UIKit

class FavLeaguesTableViewController: UITableViewController {
    var presenter : FavLeaguesPresenter!
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteItem(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
extension FavLeaguesTableViewController : FavleaguesView{
    func isLoading() {
        indecator.center = view.center
        indecator.color = UIColor(named: "PrimaryColor")
        indecator.startAnimating()
        view.addSubview(indecator)
    }
    
    func hideLoading() {
        indecator.stopAnimating()
        indecator.removeFromSuperview()
    }
    
    func listIsEmpty() {
        print("list is empty")
    }
    
    func realoadList() {
        tableView.reloadData()
    }
    
    
}
