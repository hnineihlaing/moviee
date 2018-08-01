//
//  lowerHeader.swift
//  moviee
//
//  Created by Hnin Ei Hlaing on 7/6/18.
//  Copyright © 2018 Hnin Ei Hlaing. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import Cosmos
import RealmSwift
protocol headerdelegate {
    func clickme(title: String, image: String, rating: Double, id: String, summary: String, quality: String, size: String, seeds: String, peers: String)
}

class lowerHeader: UICollectionReusableView, UICollectionViewDataSource, UICollectionViewDelegate {
    var titleArr = [String]()
    var ratingArr = [Double]()
    var summaryArr = [String]()
    var imageArr = [String]()
    var qualityArr = [String]()
    var idArr = [String]()
    var sizeArr = [String]()
    var seedsArr = [String]()
    var peersArr = [String]()
    var dataUpper = [FavMovie]()
    var delegate: headerdelegate?
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var upper: UICollectionView! {
        didSet {
            upper.dataSource = self
            upper.delegate = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! HeaderCell
        myCell.sendData(title: titleArr[indexPath.row], image: imageArr[indexPath.row], rating: ratingArr[indexPath.row], id:idArr[indexPath.row], summary: summaryArr[indexPath.row], quality: qualityArr[indexPath.row], size: sizeArr[indexPath.row], seeds: seedsArr[indexPath.row], peers: peersArr[indexPath.row])
        
        
        myCell.nameInHeader.text = titleArr[indexPath.row]
        myCell.nameInHeader.textColor = UIColor(red:1.00, green:0.23, blue:0.26, alpha:1.0)
        myCell.nameInHeader.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 19)

        //set movie image and create gradient
        myCell.image.sd_setImage(with: URL(string: imageArr[indexPath.row] ), placeholderImage: UIImage(named: "r1.jpg"))

        if myCell.gradient == false {
            let gradient = CAGradientLayer()
            gradient.frame = myCell.bounds
            gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            gradient.locations = [0.0, 1]
            myCell.image.layer.insertSublayer(gradient, at: 0)
            myCell.gradient = true
        }
        //set rating
        myCell.set(rating: ratingArr[indexPath.row]/2)

        let jj = 0 ..< titleArr.count
        for j in jj {
            var movie = FavMovie()
            movie = movie.makeFav(title: titleArr[j], image:  imageArr[j], rating:  ratingArr[j], id:  idArr[j], summary:  summaryArr[j], quality:  qualityArr[j], size: sizeArr[j], seeds: seedsArr[j], peers: peersArr[j])
        }

        //set quality
        let qtyData = qualityArr[indexPath.row]
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
        myCell.qualityCVInUpper.reloadData()
        //check if favorite
        let realm = try! Realm()
        let results = realm.objects(FavMovie.self)
        
        for movie in results {
            if idArr[indexPath.row] == movie.id {
                myCell.fav.setImage(UIImage(named: "TriangleFull.png"), for: .normal)
                break;
            }
            else {
                myCell.fav.setImage(UIImage(named: "Triangle.png"), for: .normal)
            }
        }
    
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.clickme (title: titleArr[indexPath.row], image: imageArr[indexPath.row], rating: ratingArr[indexPath.row], id: idArr[indexPath.row], summary: summaryArr[indexPath.row], quality: qualityArr[indexPath.row], size: sizeArr[indexPath.row], seeds: seedsArr[indexPath.row], peers: peersArr[indexPath.row])
    }
    
    func fetchData() {
        request(url, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            
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
                        var size = ""
                        var seeds = ""
                        var peers = ""
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
                        
                        self.titleArr.append(title)
                        self.ratingArr.append(rating!)
                        self.summaryArr.append(summary)
                        self.imageArr.append(image)
                        self.idArr.append(id)
                        self.qualityArr.append(qualityString)
                        self.seedsArr.append(seeds)
                        self.sizeArr.append(size)
                        self.peersArr.append(peers)
                        var movie = FavMovie()
                        movie = movie.makeFav(title: title, image:  image, rating:  rating!, id:  id, summary:  summary, quality:  qualityString, size: size, seeds: seeds, peers: peers)
                        self.dataUpper.append(movie)
                    }

                    self.upper?.reloadData()
                    break
                case .failure(_):
                    break
                }
            }
        })
    }
    
    public func reloadData() {
        if self.qualityArr.count == 0 {
            self.fetchData()
        }
        else {
            self.upper.reloadData()
        }
        
    }
    
}
