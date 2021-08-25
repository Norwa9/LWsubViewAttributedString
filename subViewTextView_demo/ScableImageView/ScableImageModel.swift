//
//  ScableImageModel.swift
//  subViewTextView_demo
//
//  Created by yy on 2021/8/25.
//

import Foundation
import UIKit
import SubviewAttachingTextView

class ScableImageModel: NSObject {
    var location:Int
    var imageData:Data
    var bounds:String
    var paraStyle:Int
    
    init(location:Int,imageData:Data,bounds:String,paraStyle:Int) {
        self.location = location
        self.imageData = imageData
        self.bounds = bounds
        self.paraStyle = paraStyle
        super.init()
    }
    
    
    
    
}
