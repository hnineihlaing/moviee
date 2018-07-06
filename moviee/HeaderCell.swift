//
//  HeaderCell.swift
//  moviee
//
//  Created by Hnin Ei Hlaing on 7/5/18.
//  Copyright © 2018 Hnin Ei Hlaing. All rights reserved.
//

import UIKit

class HeaderCell: UICollectionViewCell {
    @IBOutlet weak var nameInHeader: UILabel!
    @IBOutlet weak var fav: UIButton!
    
    //when heart is clicked
    @IBAction func clickHeart(_ sender: Any) {
        
        //if havent favorite
        if fav.hasImage(named: "Triangle.png", for: .normal) {
            fav.setImage(UIImage(named: "TriangleFull.png"), for: .normal)
        } else {
            fav.setImage(UIImage(named: "Triangle.png"), for: .normal)
        }
        
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
