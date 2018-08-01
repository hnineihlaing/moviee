//
//  label.swift
//  moviee
//
//  Created by Hnin Ei Hlaing on 7/11/18.
//  Copyright © 2018 Hnin Ei Hlaing. All rights reserved.
//

import Foundation
import UIKit

class UILabelPadding: UILabel {
    
    let topInset = CGFloat(20)
    let bottomInset = CGFloat(20)
    let leftInset = CGFloat(5)
    let rightInset = CGFloat(5)
    
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

