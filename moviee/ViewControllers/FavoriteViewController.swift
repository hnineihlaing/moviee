//
//  FavoriteViewController.swift
//  moviee
//
//  Created by Hnin Ei Hlaing on 7/11/18.
//  Copyright © 2018 Hnin Ei Hlaing. All rights reserved.
//

import UIKit
import RealmSwift
class FavoriteViewController: UIViewController {

    @IBOutlet weak var browse: UIButton!
    @IBOutlet weak var favorite: UIButton!
    @IBOutlet weak var favoriteCollection: UICollectionView!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set color
        view.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.12, alpha:1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.favoriteCollection.reloadData()
    }
    
    @IBAction func browseClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let realm = try! Realm()
        let a = realm.objects(FavMovie.self)
        return a.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let realm = try! Realm()
        let savedObj = realm.objects(FavMovie.self)
        
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as! favoriteCell
        
        //set title
        myCell.name.text = savedObj[indexPath.row].title
        myCell.name.textColor = UIColor(red:1.00, green:0.23, blue:0.26, alpha:1.0)
        myCell.name.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 15.0)
        
        //set image and gradient
        myCell.image.sd_setImage(with: URL(string: savedObj[indexPath.row].image ), placeholderImage: UIImage(named: "r1.jpg"))
        if myCell.gradient == false {
            let gradient = CAGradientLayer()
            gradient.frame = myCell.bounds
            gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            gradient.locations = [0.0, 1]
            myCell.image.layer.insertSublayer(gradient, at: 0)
            myCell.gradient = true
        }
        
        //set rating
        myCell.set(rating: savedObj[indexPath.row].rating/2)
        
        let qtyData = savedObj[indexPath.row].quality
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
        myCell.qualityFavCV.reloadData()
    
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let next = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let realm = try! Realm()
        let savedObj = realm.objects(FavMovie.self)
        
        //send data to detailViewController
        next.titleData = savedObj[indexPath.row].title
        next.summaryData = savedObj[indexPath.row].summary
        next.imageData = savedObj[indexPath.row].image
        next.ratingData = savedObj[indexPath.row].rating
        next.idData = savedObj[indexPath.row].id
        next.qualityData = savedObj[indexPath.row].quality
        next.sizeData = savedObj[indexPath.row].size
        next.seedsData = savedObj[indexPath.row].seeds
        next.peersData = savedObj[indexPath.row].peers
        self.navigationController?.pushViewController(next, animated: false)
    }
}


