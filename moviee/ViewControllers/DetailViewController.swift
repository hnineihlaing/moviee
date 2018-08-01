//
//  DetailViewController.swift
//  moviee
//
//  Created by Hnin Ei Hlaing on 7/11/18.
//  Copyright © 2018 Hnin Ei Hlaing. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage
import RealmSwift


class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var summaryField: UITextView!
    @IBOutlet weak var star: CosmosView!
    @IBOutlet weak var fav: UIButton!
    @IBOutlet weak var torrentsTitle: UILabel!
    @IBOutlet weak var torrents: UICollectionView!
    @IBOutlet weak var seemore: UIButton!
    
    var titleData: String? = ""
    var summaryData: String? = ""
    var imageData: String? = ""
    var ratingData: Double? = 0
    var idData: String? = ""
    var qualityData: String? = ""
    var identifier: String? = ""
    var data = [FavMovie]()
    var qualitySet = Set<String>()
    var qualityArray = [String]()
    var sizeArray = [String]()
    var seedsArray = [String]()
    var peersArray = [String]()
    var sizeData: String? = ""
    var seedsData: String? = ""
    var peersData: String? = ""
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func seemoreclicked(_ sender: Any) {
        let alertController = UIAlertController(title: "Movie Description", message:
            summaryData, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        summaryField.textContainer.lineFragmentPadding = 0
        summaryField.textContainerInset = .zero

        var quality = ""
        for char in qualityData! {
            if char == "," {
                qualityArray.append(quality)
                quality = ""
            }
            else {
                quality = quality + String(char)
            }
        }

        var size = ""
        for char in sizeData! {
            if char == "," {
                sizeArray.append(size)
                size = ""
            }
            else {
                size = size + String(char)
            }
        }
        //print(sizeArray)
        var seeds = ""
        for char in seedsData! {
            if char == "," {
                seedsArray.append(seeds)
                seeds = ""
            }
            else {
                seeds = seeds + String(char)
            }
        }
        
        var peers = ""
        for char in peersData! {
            if char == "," {
                peersArray.append(peers)
                peers = ""
            }
            else {
                peers = peers + String(char)
            }
        }
        
        torrentsTitle.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 16)
        torrents.backgroundColor = UIColor.black

        //set title
        titleLabel.text = titleData
        titleLabel.textColor = UIColor(red:1.00, green:0.23, blue:0.26, alpha:1.0)
        titleLabel.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 30)
        
        //set summary
        summaryField.text = summaryData
        summaryField.textColor = UIColor.white
        summaryField.font = UIFont(name: "SFProText-Regular", size: 12)
        
        //set image and gradient
        image.sd_setImage(with: URL(string: imageData!), placeholderImage: UIImage(named: "r1.jpg"))
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 0.7]
        image.layer.insertSublayer(gradient, at: 0)
        
        //set rating
        star.rating = ratingData!/2
        set(rating: ratingData!/2)
        
        let realm = try! Realm()
        let results = realm.objects(FavMovie.self)
        
        //check for fav
        for movie in results {
            if idData == movie.id {
                fav.setImage(UIImage(named: "TriangleFull.png"), for: .normal)
            }
            else {
                if fav.hasImage(named: "TriangleFull.png", for: .normal) {
                }
                    //else set pic to not fav
                else {
                    fav.setImage(UIImage(named: "Triangle.png"), for: .normal)
                }
            }
        }

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return qualityArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! qualityCell
        cell.quality.text = qualityArray[indexPath.row]
        cell.size.text = sizeArray[indexPath.row]
        cell.seeds.text = seedsArray[indexPath.row] + " seeds"
        cell.peers.text = peersArray[indexPath.row] + " peers"
        cell.quality.textColor = UIColor(red:0.00, green:0.79, blue:0.96, alpha:1.0)
        cell.quality.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 17)
        cell.size.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 12)
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func set(rating: Double) -> Void {
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
   
    @IBAction func favClicked(_ sender: Any) {
        //if havent favorite
        let realm = try! Realm()
        var newMovie = FavMovie()
        newMovie = newMovie.makeFav(title: titleData!, image: imageData!, rating: ratingData!, id: idData!, summary: summaryData!, quality: qualityData!, size: sizeData!, seeds: seedsData!, peers: peersData!)

        if fav.hasImage(named: "Triangle.png", for: .normal) {
            fav.setImage(UIImage(named: "TriangleFull.png"), for: .normal)
            try! realm.write {
                realm.add(newMovie, update: true)
            }
            
        } else {
            fav.setImage(UIImage(named: "Triangle.png"), for: .normal)
            try! realm.write {
                realm.delete(realm.objects(FavMovie.self).filter("id=%@",idData))
            }
        }
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}

class qualityCV: UICollectionView {
    
}

class qualityCell: UICollectionViewCell {
    @IBOutlet weak var quality: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var seeds: UILabel!
    @IBOutlet weak var peers: UILabel!
}
