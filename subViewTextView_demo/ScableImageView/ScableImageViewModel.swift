//
//  ScableImageViewModel.swift
//  subViewTextView_demo
//
//  Created by yy on 2021/8/25.
//

import Foundation
import UIKit
import SubviewAttachingTextView

class ScableImageViewModel: NSObject {
    var location:Int
    var image:UIImage
    var bounds:CGRect
    var paraStyle:NSMutableParagraphStyle
    
    init(location:Int,image:UIImage,bounds:CGRect,paraStyle:NSMutableParagraphStyle = centerParagraphStyle) {
        self.location = location
        self.image = image
        self.bounds = bounds
        self.paraStyle = paraStyle
        super.init()
    }
    
    typealias completionType = ()->(Void)
    ///view的location发生变化后，计算新的location
    func getNewestLocation(attributedString:NSAttributedString,completion:completionType){
        let fullRange = NSRange(location: 0, length: attributedString.length)
        attributedString.enumerateAttribute(.attachment, in: fullRange, options: []) { object, range, stop in
            if let attchment = object as? SubviewTextAttachment{
                if let view = attchment.viewProvider.instantiateView(for: attchment, in: SubviewAttachingTextViewBehavior.init()) as? scableImageView{
                    if view.viewModel == self{
                        let newLocation  = range.location
                        self.location = newLocation
                        print("new location : \(newLocation)")
                        completion()
                        stop.pointee = true
                        return
                    }
                }
                
            }
        }
    }
    
    
}
