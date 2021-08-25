//
//  ViewController.swift
//  subViewTextView_demo
//
//  Created by yy on 2021/8/25.
//

import UIKit
import SubviewAttachingTextView

class ViewController: UIViewController {
    var textView:SubviewAttachingTextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView = SubviewAttachingTextView(frame: view.frame)
        textView.delegate = self
        self.view.addSubview(textView)
        
        initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if let aString = loadAttributedString(id_string: "1"){
//            textView.attributedText = aString
//        }
    }
    
    func initUI(){
        //==============
        
        var text = NSAttributedString(string: "测试\n\n\n\n\n\n\n\n")
        
        let view1Model = ScableImageModel(location: text.length, image: #imageLiteral(resourceName: "bg"), bounds: CGRect(origin: .zero, size: CGSize(width: 200, height: 200)))
        let view1 = scableImageView(model: view1Model)
        view1.backgroundColor = .black
        view1.delegate = self
        text = text
            .insertingAttachment(SubviewTextAttachment(view: view1, size: view1.size), at: view1.model.location, with: view1.model.paraStyle)
        
        let view2Model = ScableImageModel(location: text.length, image: #imageLiteral(resourceName: "bg"), bounds: CGRect(origin: .zero, size: CGSize(width: 200, height: 200)))
        let view2 = scableImageView(model: view2Model)
        view2.backgroundColor = .black
        view2.delegate = self
        text = text
            .insertingAttachment(SubviewTextAttachment(view: view2, size: view2.size), at: view2.model.location, with: view2.model.paraStyle)
        

        // Add attachments to the string and set it on the text view
        // This example avoids evaluating the attachments or attributed strings with attachments in the Playground because Xcode crashes trying to decode attachment objects
        textView.attributedText = text
    }
    

}

extension ViewController : scableImageViewDelegate{
    func reloadScableImage(endView:scableImageView){
        
        let newModel = endView.model
        newModel.bounds = endView.frame
        newModel.getNewestLocation(attributedString: textView.attributedText){
            let newView = scableImageView(model: newModel)
            newView.delegate = self
            newView.backgroundColor = .gray
            let newAttchment = SubviewTextAttachment(view: newView, size: newView.size)
            
            let mutable = NSMutableAttributedString(attributedString: textView.attributedText!)
            print("newView.model.location : \(newView.model.location)")
            mutable.replaceAttchment(newAttchment, attchmentAt: newView.model.location, with: newView.model.paraStyle)
            textView.attributedText = mutable
            textView.selectedRange = NSRange(location: newView.model.location, length: 0)
        }
    }
}

extension ViewController : UITextViewDelegate{
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        saveAttributedString(id_string: "1", aString: textView.attributedText)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
        saveAttributedString(id_string: "1", aString: textView.attributedText)
    }
    
}

extension SubviewTextAttachment{
    var view:UIView{
        get{
            return self.viewProvider.instantiateView(for: self, in: SubviewAttachingTextViewBehavior.init())
        }
    }
}
