//
//  LeaguesTableViewController.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 30/04/2026.
//

import UIKit

class LeaguesTableViewController: UITableViewController {
    var presenter : LeaguesPresenterProtocol!
    var indecator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SportLeaguesTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SportLeaguesTableViewCell")
        presenter.fetchLeagues()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getListCount()
    }

    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "SportLeaguesTableViewCell",
            for: indexPath
        ) as! SportLeaguesTableViewCell

        let league = presenter.getListItem(index: indexPath.row)

        cell.leagueName.text = league.name

        presenter.fetchImageData(from: league.badgeURL ?? "") { [weak self] data in

            guard let self = self,
                  let data = data else { return }

            DispatchQueue.main.async {

                if let visibleCell = tableView.cellForRow(at: indexPath) as? SportLeaguesTableViewCell {
                    visibleCell.leagueImage.image = UIImage(data: data)
                }
            }
        }

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

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
extension LeaguesTableViewController : LeaguesView{
    
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
