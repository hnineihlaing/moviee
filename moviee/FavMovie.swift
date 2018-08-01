//
//  obj.swift
//  moviee
//
//  Created by Hnin Ei Hlaing on 7/9/18.
//  Copyright © 2018 Hnin Ei Hlaing. All rights reserved.
//

import UIKit
import RealmSwift

class FavMovie: Object {
    @objc dynamic var title = ""
    @objc dynamic var image = ""
    @objc dynamic var rating = 0.0
    @objc dynamic var id = ""
    @objc dynamic var summary = ""
    @objc dynamic var quality = ""
    @objc dynamic var size = ""
    @objc dynamic var seeds = ""
    @objc dynamic var peers = ""

    func makeFav(title: String, image: String, rating: Double, id: String, summary: String, quality: String, size: String, seeds: String, peers: String) -> FavMovie {
        let newMovie = FavMovie()
        newMovie.title = title
        newMovie.image = image
        newMovie.rating = rating
        newMovie.id = id
        newMovie.summary = summary
        newMovie.quality = quality
        newMovie.size = size
        newMovie.seeds = seeds
        newMovie.peers = peers
        return newMovie
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

