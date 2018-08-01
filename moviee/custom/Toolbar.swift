//
//  Toolbar.swift
//  moviee
//
//  Created by Hnin Ei Hlaing on 7/9/18.
//  Copyright © 2018 Hnin Ei Hlaing. All rights reserved.
//

import UIKit

class Toolbar: UIToolbar {
   
    override func layoutSubviews() {
        super.layoutSubviews()
        frame.size.height = 57
    }
        
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 57
        return size
    }


}
