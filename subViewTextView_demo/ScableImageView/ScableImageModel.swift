//
//  ScableImageModel.swift
//  subViewTextView_demo
//
//  Created by yy on 2021/8/25.
//

import Foundation
import UIKit

class ScableImageModel: NSObject {
    var location:Int
    var image:UIImage
    var bounds:CGRect
    
    init(location:Int,image:UIImage,bounds:CGRect) {
        self.location = location
        self.image = image
        self.bounds = bounds
        
        super.init()
    }
    
}
