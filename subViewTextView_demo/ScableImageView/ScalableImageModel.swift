//
//  ScableImageModel.swift
//  subViewTextView_demo
//
//  Created by yy on 2021/8/25.
//

import Foundation
import UIKit
import SubviewAttachingTextView
import YYModel
import YYImage

class ScalableImageModel: NSObject,Codable,YYModel {
    @objc dynamic var location:Int = -1
    @objc dynamic var imageData:Data? = nil
    @objc dynamic var bounds:String = ""
    @objc dynamic var paraStyle:Int = -1
    @objc dynamic var contentMode:Int = -1
    
    override init() {
        super.init()
    }
    
    init(location:Int,image:UIImage,bounds:String,paraStyle:Int,contentMode:Int) {
        self.location = location
//        let jpegEncoder = YYImageEncoder(type: .JPEG)
//        jpegEncoder?.quality = 0.9
//        jpegEncoder?.add(image, duration: 0)
//        let jpegData = jpegEncoder?.encode()
//        self.imageData = jpegData
        
        self.imageData = "123".data(using: .utf16)!
        
//        self.imageData = image.jpegData(compressionQuality: 0.8)
        
        self.bounds = bounds
        self.paraStyle = paraStyle
        self.contentMode = contentMode
        super.init()
    }
    
    override class func yy_modelEncode(with aCoder: NSCoder) {
        self.yy_modelEncode(with: aCoder)
    }
    
    
    
    
}
