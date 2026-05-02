//
//  HomeCollectionViewController.swift
//  Top-League
//
//  Created by JETSMobileLabMini12 on 29/04/2026.
//

import UIKit

class HomeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var presnter = HomePresenter()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let nib = UINib(nibName: "HomeCustomCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "HomeCustomCell")
        
        // Do any additional setup after loading the view.
    }


    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
        })
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = collectionView.bounds.width

        let columns: CGFloat = width > 500 ? 4 : 2

        let spacing: CGFloat = 15
        let inset: CGFloat = 20

        let totalSpacing = ((columns - 1) * spacing) + (inset * 2)

        let cellWidth = (width - totalSpacing) / columns

        return CGSize(width: cellWidth, height: 170)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch section {
//            case 1:
//                return 1
//            default:
//
//        }
        return 4
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCustomCell", for: indexPath) as! HomeCustomCell
        let title = presnter.getCollectionItem(index: indexPath.row)
        cell.SportImage.image = UIImage(named:title)
        cell.SportName.text = title.uppercased()
        
    
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LeaguesTableViewController") as! LeaguesTableViewController
        vc.presenter = LeaguesPresenter(index: indexPath.row, view: vc)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
