//
//  ViewController.swift
//  moviee
//
//  Created by Hnin Ei Hlaing on 7/30/18.
//  Copyright © 2018 Hnin Ei Hlaing. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import Cosmos
import RealmSwift

let url = "https://yts.am/api/v2/list_movies.json?sort_by=download_count"
var urlLower = "https://yts.am/api/v2/list_movies.json?limit=20"

class ViewController: UIViewController , headerdelegate{
   
    @IBOutlet weak var browse: UIButton!
    @IBOutlet weak var favorite: UIButton!
    @IBOutlet weak var search: UIButton!
    @IBOutlet weak var lower: UICollectionView!
    
    private var header: lowerHeader!
    
    var titleArr = [String]()
    var ratingArr = [Double]()
    var summaryArr = [String]()
    var imageArr = [String]()
    var qualityArr = [String]()
    var imageLowerArr = [String]()
    var titleLowerArr = [String]()
    var ratingLowerArr = [Double]()
    var summaryLowerArr = [String]()
    var qualityLowerArr = [String]()
    var idArr = [String]()
    var idLowerArr = [String]()
    var data = [FavMovie]()
    var dataUpper = [FavMovie]()
    var dataLower = [FavMovie]()
    var sizeLowerArr = [String]()
    var sizeArr = [String]()
    var seedsLowerArr = [String]()
    var seedsArr = [String]()
    var peersLowerArr = [String]()
    var peersArr = [String]()
    var isLoading = false
    var page = 2
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.header?.reloadData()
    }

    @IBAction func searchClicked(_ sender: Any) {
        let next = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController

        next.data = [FavMovie]()
        dataUpper = [FavMovie]()
        dataLower = [FavMovie]()
        if titleArr.count == 0 {
            self.header?.reloadData()
        }
        //send data to SearchViewController

        let kk = 0 ..< titleLowerArr.count
        for k in kk {
            var movie = FavMovie()
            movie = movie.makeFav(title: titleLowerArr[k], image:  imageLowerArr[k], rating:  ratingLowerArr[k], id:  idLowerArr[k], summary:  summaryLowerArr[k], quality:  qualityLowerArr[k], size: sizeLowerArr[k], seeds: seedsLowerArr[k], peers: peersLowerArr[k])
            dataLower.append(movie)
        }
        if (self.header?.titleArr.count)! > 0 {
            dataUpper = (self.header?.dataUpper)!
            next.data = dataUpper + dataLower
        }
        self.navigationController?.pushViewController(next, animated: false)
        
    }
    
    @IBAction func favoriteClicked(_ sender: Any) {
        let next = storyboard?.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
        self.navigationController?.pushViewController(next, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        
        //lower
        request(urlLower, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            DispatchQueue.main.async {
                switch response.result {
                case .success( _):
                    let json = JSON(response.result.value!)
                    
                    let ii = 0 ..< json["data"]["movies"].count
                    for i in ii {
                        let title = json["data"]["movies"][i]["title"].stringValue.uppercased()
                        let rating = json["data"]["movies"][i]["rating"].double
                        let summary = json["data"]["movies"][i]["summary"].stringValue
                        let image = json["data"]["movies"][i]["large_cover_image"].stringValue
                        let id = json["data"]["movies"][i]["id"].stringValue
                        let num = json["data"]["movies"][i]["torrents"].count
                        var size = ""
                        var seeds = ""
                        var peers = ""
                        var qualityString = ""
                        var qualitySet = Set<String>()
                        
                        let jj = 0 ..< num
                        for j in jj {
                            if qualitySet.contains(json["data"]["movies"][i]["torrents"][j]["quality"].stringValue) {
                                
                            }
                            else {
                                qualitySet.insert(json["data"]["movies"][i]["torrents"][j]["quality"].stringValue)
                                qualityString = qualityString + json["data"]["movies"][i]["torrents"][j]["quality"].stringValue
                                size = size + json["data"]["movies"][i]["torrents"][j]["size"].stringValue
                                seeds = seeds + json["data"]["movies"][i]["torrents"][j]["seeds"].stringValue
                                peers = peers + json["data"]["movies"][i]["torrents"][j]["peers"].stringValue
                                
                                if j != num {
                                    qualityString = qualityString + ","
                                    size = size + ","
                                    seeds = seeds + ","
                                    peers = peers + ","
                                }
                            }
                        }
                        
                        self.titleLowerArr.append(title)
                        self.ratingLowerArr.append(rating!)
                        self.summaryLowerArr.append(summary)
                        self.imageLowerArr.append(image)
                        self.idLowerArr.append(id)
                        self.qualityLowerArr.append(qualityString)
                        self.seedsLowerArr.append(seeds)
                        self.sizeLowerArr.append(size)
                        self.peersLowerArr.append(peers)
                    }
                    self.lower.reloadData()
                    break
                case .failure(_):
                    break
                }
            }
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellB", for: indexPath) as! MyCell
        
        //set background color
        collectionView.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.12, alpha:1.0)
        myCell.backgroundColor = UIColor.brown

        if titleLowerArr.count > 0 {

            //set movie title
            myCell.name.text = titleLowerArr[indexPath.row]
            myCell.name.textColor = UIColor(red:1.00, green:0.23, blue:0.26, alpha:1.0)
            myCell.name.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 15.0)

            //set image and gradient
            myCell.image.sd_setImage(with: URL(string: imageLowerArr[indexPath.row] ), placeholderImage: UIImage(named: "r1.jpg"))

            if myCell.gradient == false {
                let gradient = CAGradientLayer()
                gradient.frame = myCell.bounds
                gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
                gradient.locations = [0.0, 1]
                myCell.image.layer.insertSublayer(gradient, at: 0)
                myCell.gradient = true
            }


            //set rating
            myCell.set(rating: ratingLowerArr[indexPath.row]/2)

            let kk = 0 ..< titleLowerArr.count
            for k in kk {
                var movie = FavMovie()
                movie = movie.makeFav(title: titleLowerArr[k], image:  imageLowerArr[k], rating:  ratingLowerArr[k], id:  idLowerArr[k], summary:  summaryLowerArr[k], quality:  qualityLowerArr[k], size: sizeLowerArr[k], seeds: seedsLowerArr[k], peers: peersLowerArr[k])
                dataLower.append(movie)
            }
            let qtyData = dataLower[indexPath.row].quality
            var quality = ""
            var qualitySet = Set<String>()
            var qualityArray = [String]()
            for char in qtyData {
                if char == "," {
                    if qualitySet.contains(quality){
                        quality = ""
                    }
                    else {
                        qualitySet.insert(quality)
                        qualityArray.append(quality)
                        quality = ""
                    }
                }
                else {
                    quality = quality + String(char)
                }
            }

            myCell.qtyAry = qualityArray
            myCell.qualityCVInLower.reloadData()
        }

        return myCell
   // }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleLowerArr.count

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let next = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController

        //send data to detailViewController

        next.titleData = titleLowerArr[indexPath.row]
        next.summaryData = summaryLowerArr[indexPath.row]
        next.imageData = imageLowerArr[indexPath.row]
        next.ratingData = ratingLowerArr[indexPath.row]
        next.idData = idLowerArr[indexPath.row]
        next.qualityData = qualityLowerArr[indexPath.row]
        next.sizeData = sizeLowerArr[indexPath.row]
        next.seedsData = seedsLowerArr[indexPath.row]
        next.peersData = peersLowerArr[indexPath.row]

        self.navigationController?.pushViewController(next, animated: false)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "lowerFooter", for: indexPath) as! LowerFooter
            return footer
        default:
            
            self.header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "lowerHeader", for: indexPath) as! lowerHeader
           header.delegate = self
            //header of lower collectionview
            if titleArr.count > 0 {
                self.header.fetchData()
            }
            
            return header
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if collectionView == self.lower {
            let lastItem = titleLowerArr.count - 1
            if indexPath.row == lastItem  && !isLoading {

                let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: 0, y: 0, width: self.lower.bounds.width, height: 44)

                self.loadData()
            }
        }
    }

    func loadData() {

        isLoading = true
        let tempUrl = urlLower
        urlLower = urlLower + "&page=" + String(page)
        page = page + 1
        request(urlLower, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            DispatchQueue.main.async {
                switch response.result {
                case .success( _):
                    let json = JSON(response.result.value!)
                    let ii = 0 ..< json["data"]["movies"].count
                    for i in ii {
                        let title = json["data"]["movies"][i]["title"].stringValue.uppercased()
                        let rating = json["data"]["movies"][i]["rating"].double
                        let summary = json["data"]["movies"][i]["summary"].stringValue
                        let image = json["data"]["movies"][i]["large_cover_image"].stringValue
                        let id = json["data"]["movies"][i]["id"].stringValue
                        let num = json["data"]["movies"][i]["torrents"].count
                        
                        var qualityString = ""
                        var qualitySet = Set<String>()
                        var size = ""
                        var seeds = ""
                        var peers = ""
                        let jj = 0 ..< num
                        for j in jj {
                            if qualitySet.contains(json["data"]["movies"][i]["torrents"][j]["quality"].stringValue) {
                                
                            }
                            else {
                                qualitySet.insert(json["data"]["movies"][i]["torrents"][j]["quality"].stringValue)
                                qualityString = qualityString + json["data"]["movies"][i]["torrents"][j]["quality"].stringValue
                                size = size + json["data"]["movies"][i]["torrents"][j]["size"].stringValue
                                seeds = seeds + json["data"]["movies"][i]["torrents"][j]["seeds"].stringValue
                                peers = peers + json["data"]["movies"][i]["torrents"][j]["peers"].stringValue
                                
                                if j != num {
                                    qualityString = qualityString + ","
                                    size = size + ","
                                    seeds = seeds + ","
                                    peers = peers + ","
                                }
                            }
                        }
                        
                        self.titleLowerArr.append(title)
                        self.ratingLowerArr.append(rating!)
                        self.summaryLowerArr.append(summary)
                        self.imageLowerArr.append(image)
                        self.idLowerArr.append(id)
                        self.qualityLowerArr.append(qualityString)
                        self.seedsLowerArr.append(seeds)
                        self.sizeLowerArr.append(size)
                        self.peersLowerArr.append(peers)
                        
                    }
                    
                    self.isLoading = false
                    
                    self.lower.reloadData()
                    
                    let kk = 0 ..< self.titleLowerArr.count
                    self.dataLower = [FavMovie]()
                    for k in kk {
                        var movie = FavMovie()
                        movie = movie.makeFav(title: self.titleLowerArr[k], image:  self.imageLowerArr[k], rating:  self.ratingLowerArr[k], id:  self.idLowerArr[k], summary:  self.summaryLowerArr[k], quality:  self.qualityLowerArr[k], size: self.sizeLowerArr[k], seeds: self.seedsLowerArr[k], peers: self.peersLowerArr[k])
                        self.dataLower.append(movie)
                    }
                    
                    urlLower = tempUrl
                    break
                    
                case .failure(_):
                    break
                }
            }
            
        })
    }
    func clickme(title: String, image: String, rating: Double, id: String, summary: String, quality: String, size: String, seeds: String, peers: String) {
        let next = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController

        //send data to detailViewController

        next.titleData = title
        next.summaryData = summary
        next.imageData = image
        next.ratingData = rating
        next.idData = id
        next.qualityData = quality
        next.sizeData = size
        next.seedsData = seeds
        next.peersData = peers

        self.navigationController?.pushViewController(next, animated: false)
    }
}
