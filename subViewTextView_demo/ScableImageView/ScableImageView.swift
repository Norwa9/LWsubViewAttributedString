//
//  LWImageView.swift
//  BSTextDemo
//
//  Created by 罗威 on 2021/8/24.
//  Copyright © 2021 GeekBruce. All rights reserved.
//

import Foundation
import UIKit
import PopMenu

protocol scableImageViewDelegate : NSObject {
    func reloadScableImage(endView:scableImageView)
}

class scableImageView:UIView, UIGestureRecognizerDelegate{
    private var dotView:UIView!
    private var imageView:UIImageView!
    private var dot: UIView?
    weak var delegate:scableImageViewDelegate?
    
    var viewModel:ScableImageViewModel
    
    init(viewModel:ScableImageViewModel) {
        self.viewModel = viewModel
        super.init(frame: viewModel.bounds)
        
        initUI()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI(){
        //1.imageView
        imageView = UIImageView(image: UIImage(named: "bg2"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        imageView.frame = self.bounds
        
        //2.dotView
        if viewModel.isEditing{
             addDotView()
        }
        
        //3.tap gesture
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(handle(_:)))
        self.addGestureRecognizer(tapGes)
    }
    
    func addDotView(){
        weak var wlabel = self
        dot = newDotView()
        dot?.center = CGPoint(x: self.width, y: self.height)
        dot?.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
        if let dot = dot {
            self.addSubview(dot)
        }
        let gesture = BSGestureRecognizer()
        gesture.targetView = self
        gesture.action = { gesture, state in
            if state == BSGestureRecognizerState.moved {
                let width = gesture!.currentPoint.x
                let height = gesture!.currentPoint.y
                wlabel?.width = width < 30 ? 30 : width
                wlabel?.height = height < 30 ? 30 : height
            }else if state == .ended{
                self.delegate?.reloadScableImage(endView: self)
            }
        }
        gesture.delegate = self
        dot?.addGestureRecognizer(gesture)
    }
    
    func removeDotView(){
        dot?.removeFromSuperview()
    }
    
    private func newDotView() -> UIView? {
        let view = UIView()
        view.size = CGSize(width: 50, height: 50)
        
        let dot = UIView()
        dot.size = CGSize(width: 30, height: 30)
        dot.backgroundColor = UIColor(red: 0.000, green: 0.463, blue: 1.000, alpha: 1.000)
        dot.clipsToBounds = true
        dot.layer.cornerRadius = dot.height / 2
        dot.center = CGPoint(x: view.width / 2, y: view.height / 2)
        view.addSubview(dot)
        
        return view
    }
    
    
}

extension scableImageView{
    @objc func handle(_ sender: UIGestureRecognizer!) {
        print("tapped")
        if let view = sender.view as? scableImageView{
            if view == self{
                
                let popManager = PopMenuManager.default
                popManager.actions = [
                    PopMenuDefaultAction(title: "编辑",didSelect: { action in
                        view.viewModel.isEditing.toggle()
                        let isEditing = view.viewModel.isEditing
                        if isEditing{
                            self.addDotView()
                        }else{
                            self.removeDotView()
                        }
                    }),
                    PopMenuDefaultAction(title: "居中",didSelect: { action in
                        view.viewModel.paraStyle = centerParagraphStyle
                        self.delegate?.reloadScableImage(endView: view)
                    }),
                    PopMenuDefaultAction(title: "居左",didSelect: { action in
                        view.viewModel.paraStyle = leftParagraphStyle
                        self.delegate?.reloadScableImage(endView: view)
                    }),
                    PopMenuDefaultAction(title: "居右",didSelect: { action in
                        view.viewModel.paraStyle = rightParagraphStyle
                        self.delegate?.reloadScableImage(endView: view)
                    }),
                ]
                popManager.present(sourceView: self, on: nil, animated: true, completion: nil)
                
            }
        }
    }
    
    
    
}

extension scableImageView{
    /// 子视图超出本视图的部分也能接收事件
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    
        if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01 ){
            return nil
        }
        let resultView  = super.hitTest(point, with: event)
        if resultView != nil {
            return resultView
        } else {
            for subView in self.subviews.reversed() {
                // 这里根据层级的不同，需要遍历的次数可能不同，看需求来写，我写的例子是一层的
                let convertPoint : CGPoint = subView.convert(point, from: self)
                let hitView = subView.hitTest(convertPoint, with: event)
                if (hitView != nil) {
                    return hitView
                }
            }
        }
        return nil
    }
}
