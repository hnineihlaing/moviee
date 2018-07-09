//
//  ViewController.swift
//  moviee
//
//  Created by Hnin Ei Hlaing on 7/3/18.
//  Copyright © 2018 Hnin Ei Hlaing. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let url = "https://yts.am/api/v2/list_movies.json?limit=5"
//let url = "https://yts.am/api/v2/"
class ViewController: UIViewController {
    
    @IBOutlet weak var lower: UICollectionView!
    @IBOutlet weak var upper: UICollectionView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var favorite: UIButton!
    @IBOutlet weak var browse: UIButton!
    @IBOutlet weak var topRated: UILabel!
  //  @IBOutlet weak var list: UILabel!
    @IBOutlet weak var searchbox: UITableView!
    //var title = [String]()
    var arrRes = [[String:AnyObject]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //STICKY HEADER????
        if let layout = lower.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }
        searchbox.isHidden = true
        searchbox.backgroundColor = UIColor.blue
        //set background color
        view.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.12, alpha:1.0)
        
        browse.setTitle("BROWSE", for: .normal)
        browse.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 14)
        browse.setTitleColor(.white, for: .normal)
        
        favorite.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 14)
        favorite.setTitle("FAVORITES", for: .normal)
        favorite.setTitleColor(.lightGray, for: .normal)
        
        topRated.text = "Top Rated"
        topRated.textColor = UIColor.lightGray
        topRated.font =  UIFont(name: "SFProText-Regular", size: 3)
        topRated.font = topRated.font.withSize(15)
        
       // list.text = "List"
     //   list.textColor = UIColor.lightGray
       // list.font =  UIFont(name: "SFProText-Regular", size: 3)
       // list.font = list.font.withSize(15)
        /*
        let parameters : [String: Any] = [
            "title" : title
        ]
        request(url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(response.result.value!)
                if let resData = json[].arrayObject {
                    self.title = resData as [AnyObject] as! [String]; ()
                }
                //let json = value as! [String: Any]
                //let datas = json["title"] as! [String]
           //    let ii = 0 ..< datas.count
           //     for i in ii {
 
             //       self.title.append(datas[i])
             //   }
                //self.arrRes = json["title"] as! [[String : AnyObject]]
                
                break
                
            case .failure(let error):
                break
            }
        })*/
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.upper {
            return 5
        }
        else {
            return 20
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "lowerHeader", for: indexPath) as! lowerHeader
            header.list.text = "List"
            header.list.textColor = UIColor.lightGray
            header.list.font =  UIFont(name: "SFProText-Regular", size: 3)
            header.list.font = header.list.font.withSize(15)
            header.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.12, alpha:1.0)
            return header
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.upper {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! HeaderCell
            collectionView.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.12, alpha:1.0)
            myCell.backgroundColor = UIColor.blue
            //var dict = arrRes[0]
            //myCell.nameInHeader?.text = dict["title"] as? String
            //myCell.nameInHeader.text = "ADAM SANDLER'S"
            myCell.nameInHeader.textColor = UIColor(red:1.00, green:0.23, blue:0.26, alpha:1.0)
            myCell.nameInHeader.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 22)
            return myCell
        }
            
        else {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellB", for: indexPath) as! MyCell
            collectionView.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.12, alpha:1.0)
            myCell.backgroundColor = UIColor.brown
           // myCell.name.text = "ADAM SANDLER'S"
            //myCell.backgroundColor = UIColor.gray
            myCell.name.textColor = UIColor(red:1.00, green:0.23, blue:0.26, alpha:1.0)
            myCell.name.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 16.0)
            
            return myCell
        }
    }
}

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



/*
class UILabelPadding: UILabel {
    
    let topInset = CGFloat(0)
    let bottomInset = CGFloat(0)
    let leftInset = CGFloat(70)
    let rightInset = CGFloat(70)
    
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}

class customCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
 //   @IBOutlet weak var image: UIButton!
    @IBOutlet weak var box: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var one: UILabelPadding!
    @IBOutlet weak var seven: UILabelPadding!
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell:customCell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! customCell
        
        myCell.one.text = "1080p"
        myCell.one.layer.cornerRadius = 5
        myCell.one.layer.masksToBounds = true
        myCell.one.layer.backgroundColor = UIColor.clear.cgColor
        myCell.one.layer.borderWidth = 2
        myCell.one.layer.borderColor = UIColor(red:0.00, green:0.79, blue:0.96, alpha:1.0).cgColor
         myCell.one.textColor = UIColor(red:0.00, green:0.79, blue:0.96, alpha:1.0)
        myCell.one.font = UIFont.boldSystemFont(ofSize: 10)
        myCell.one.textAlignment = .center
        
        myCell.seven.text = "720p"
        myCell.seven.layer.cornerRadius = 5
        myCell.seven.layer.masksToBounds = true
        myCell.seven.layer.backgroundColor = UIColor.clear.cgColor
        myCell.seven.layer.borderWidth = 2
        myCell.seven.textColor = UIColor(red:0.00, green:0.79, blue:0.96, alpha:1.0)
        myCell.seven.layer.borderColor = UIColor(red:0.00, green:0.79, blue:0.96, alpha:1.0).cgColor
       // myCell.seven.font = UIFont.boldSystemFont(ofSize: 10)
        myCell.seven.textAlignment = .center
        myCell.seven.font = UIFont(name: "SFProText-Regular", size: 5.0)
        
        myCell.label.text = "ADAM SANDLER'S"
        myCell.backgroundColor = UIColor.gray
        myCell.label.textColor = UIColor(red:1.00, green:0.23, blue:0.26, alpha:1.0)
        myCell.label.font = UIFont(name: "HelveticaNeue-CondensedBold", size: 22.0)
        return myCell
    }
    
*/

