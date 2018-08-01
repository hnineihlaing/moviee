//
//  SearchViewController.swift
//  moviee
//
//  Created by Hnin Ei Hlaing on 7/16/18.
//  Copyright © 2018 Hnin Ei Hlaing. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos

class SearchViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var filteredData: [FavMovie]!
    var data = [FavMovie]()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        searchBar.setImage(UIImage(named: "Group 4.png"), for: .bookmark, state: .normal)

        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        let imageV = textFieldInsideSearchBar?.leftView as! UIImageView
        imageV.image = imageV.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imageV.tintColor = UIColor(red:0.11, green:0.11, blue:0.12, alpha:1.0)
        
        tableView.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.12, alpha:1.0)

        filteredData = data

        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let qtyData = filteredData[indexPath.row].quality
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! searchcell
        
        cell.title.text = filteredData[indexPath.row].title
        
        cell.title.textColor = UIColor(red:1.00, green:0.23, blue:0.26, alpha:1.0)
        cell.title.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 19)
        
        cell.movieImage.sd_setImage(with: URL(string: filteredData[indexPath.row].image ), placeholderImage: UIImage(named: "r1.jpg"))
        
        var quality = ""
        var qualityArray = [String]()
        for char in qtyData {
            if char == "," {
                qualityArray.append(quality)
                quality = ""
            }
                
            else {
                quality = quality + String(char)
            }
        }
        
        cell.qtyAry = qualityArray
        cell.set(rating: filteredData[indexPath.row].rating/2)
        cell.qualityCV.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let next = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        next.titleData = filteredData[indexPath.row].title
        next.summaryData = filteredData[indexPath.row].summary
        next.imageData = filteredData[indexPath.row].image
        next.ratingData = filteredData[indexPath.row].rating
        next.idData = filteredData[indexPath.row].id
        next.qualityData = filteredData[indexPath.row].quality
        next.sizeData = filteredData[indexPath.row].size
        next.seedsData = filteredData[indexPath.row].seeds
        next.peersData = filteredData[indexPath.row].peers
        next.data = data
        self.navigationController?.pushViewController(next, animated: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0 {
            filteredData = data
            self.tableView.reloadData()
        }
        else {
            filteredData = data.filter({ (text : FavMovie) -> Bool in
                return text.title.lowercased().contains(searchText.lowercased())
            })
            self.tableView.reloadData()
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension searchcell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return qtyAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "qualityCell", for: indexPath) as! cellInQualityCV
        cell.label.text = qtyAry[indexPath.row]
        cell.label.layer.cornerRadius = 5
        cell.label.layer.masksToBounds = true
        cell.label.layer.backgroundColor = UIColor.clear.cgColor
        cell.label.layer.borderWidth = 2
        cell.label.layer.borderColor = UIColor(red:0.00, green:0.79, blue:0.96, alpha:1.0).cgColor
        cell.label.textColor = UIColor(red:0.00, green:0.79, blue:0.96, alpha:1.0)
        cell.label.font = UIFont.boldSystemFont(ofSize: 12)
        cell.label.textAlignment = .center
        return cell
    }
}

class qualityCollectionView: UICollectionView {
    
}

class cellInQualityCV: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
}

class searchcell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var star: CosmosView!
    var qtyAry = [String]()
    @IBOutlet weak var qualityCV: UICollectionView! {
        didSet {
            qualityCV.dataSource = self
            qualityCV.delegate = self
        }
    }
    
    func set(rating: Double) -> Void {
        self.star.rating = rating
        self.star.settings.starSize = 10
        self.star.settings.fillMode = .precise
        self.star.settings.filledColor = UIColor.white
        self.star.settings.emptyBorderColor = UIColor.clear
        self.star.backgroundColor = UIColor.clear
        self.star.settings.filledBorderColor = UIColor.white
        self.star.settings.starMargin = 1
        self.star.settings.updateOnTouch = false
        self.star.settings.emptyColor = UIColor.clear
    }
}


