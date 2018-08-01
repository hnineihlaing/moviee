//
//  File.swift
//  moviee
//
//  Created by Hnin Ei Hlaing on 7/11/18.
//  Copyright © 2018 Hnin Ei Hlaing. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.lower {
            return CGSize(width: (collectionView.bounds.size.width/2), height: (collectionView.bounds.size.width/2))
        }
        else {
            return CGSize(width: (collectionView.bounds.size.width * 0.7), height: collectionView.bounds.size.height)
        }
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.size.width/2), height: (collectionView.bounds.size.width/2))
    }
}
