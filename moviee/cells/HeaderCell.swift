//
//  HeaderCell.swift
//  moviee
//
//  Created by Hnin Ei Hlaing on 7/5/18.
//  Copyright © 2018 Hnin Ei Hlaing. All rights reserved.
//

import UIKit
import Cosmos
import RealmSwift

class HeaderCell: UICollectionViewCell {
    @IBOutlet weak var nameInHeader: UILabel!
    @IBOutlet weak var fav: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var star: CosmosView!
    
    @IBOutlet weak var qualityCVInUpper: headerQuality! {
        didSet {
            qualityCVInUpper.dataSource = self
            qualityCVInUpper.delegate = self
        }
    }
    
    var qtyAry = [String]()
    var title = ""
    var imageData = ""
    var rating = 0.0
    var id = ""
    var summary = ""
    var quality = ""
    var size = ""
    var seeds = ""
    var peers = ""
    var gradient = false
    
    //when heart is clicked
    override func awakeFromNib() {
        super.awakeFromNib()
        fav.addTarget(self, action: #selector(clickHeart), for: .touchUpInside)
    }
    
    @IBAction func clickHeart(_ sender: Any) {
        let realm = try! Realm()
        var newMovie = FavMovie()
        newMovie = newMovie.makeFav(title: self.title, image: self.imageData, rating: Double(self.rating), id: self.id, summary: self.summary,quality: self.quality, size: self.size, seeds: self.seeds, peers: self.peers)

        if fav.hasImage(named: "Triangle.png", for: .normal) {
            
            fav.setImage(UIImage(named: "TriangleFull.png"), for: .normal)

            try! realm.write {
                realm.add(newMovie, update: true)
            }

        } else {
            fav.setImage(UIImage(named: "Triangle.png"), for: .normal)

            try! realm.write {
                realm.delete(realm.objects(FavMovie.self).filter("id=%@",self.id))
            }
        }
        
    }
    
    func sendData(title: String, image: String, rating: Double, id: String, summary:String, quality: String, size: String, seeds: String, peers: String) -> Void {
        self.title = title
        self.imageData = image
        self.rating = rating
        self.id = id
        self.summary = summary
        self.quality = quality
        self.size = size
        self.seeds = seeds
        self.peers = peers
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

extension UIButton {
    func hasImage(named imageName: String, for state: UIControlState) -> Bool {
        guard let buttonImage = image(for: state), let namedImage = UIImage(named: imageName) else {
            return false
        }
        
        return UIImagePNGRepresentation(buttonImage) == UIImagePNGRepresentation(namedImage)
    }
}

extension HeaderCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return qtyAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerQualityCell", for: indexPath) as! headerQualityCell
        cell.label.text = qtyAry[indexPath.row]
        cell.label.layer.cornerRadius = 5
        cell.label.layer.masksToBounds = true
        cell.label.layer.backgroundColor = UIColor.clear.cgColor
        cell.label.layer.borderWidth = 2
        cell.label.layer.borderColor = UIColor(red:0.00, green:0.79, blue:0.96, alpha:1.0).cgColor
        cell.label.textColor = UIColor(red:0.00, green:0.79, blue:0.96, alpha:1.0)
        cell.label.font = UIFont.boldSystemFont(ofSize: 10)
        cell.label.textAlignment = .center

        return cell
    }
}

class headerQuality: UICollectionView {
    
}

class headerQualityCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
}
