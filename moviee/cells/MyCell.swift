//
//  MyCell.swift
//  moviee
//
//  Created by Hnin Ei Hlaing on 7/5/18.
//  Copyright © 2018 Hnin Ei Hlaing. All rights reserved.
//

import UIKit
import Cosmos

class MyCell: UICollectionViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var star: CosmosView!
    
    @IBOutlet weak var qualityCVInLower: LowerQuality! {
        didSet {
            qualityCVInLower.dataSource = self
            qualityCVInLower.delegate = self
        }
    }
    
    var qualityadded = false
    var gradient = false
    var qtyAry = [String]()
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

extension MyCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return qtyAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LowerQualityCell", for: indexPath) as! LowerQualityCell
        cell.label.text = qtyAry[indexPath.row]
        cell.label.layer.cornerRadius = 5
        cell.label.layer.masksToBounds = true
        cell.label.layer.backgroundColor = UIColor.clear.cgColor
        cell.label.layer.borderWidth = 2
        cell.label.layer.borderColor = UIColor(red:0.00, green:0.79, blue:0.96, alpha:1.0).cgColor
        cell.label.textColor = UIColor(red:0.00, green:0.79, blue:0.96, alpha:1.0)
        cell.label.font = UIFont.boldSystemFont(ofSize: 8)
        cell.label.textAlignment = .center

        return cell
    }
}

class LowerQuality: UICollectionView {
    
}

class LowerQualityCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
}
