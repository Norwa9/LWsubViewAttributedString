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
        
        var text = NSAttributedString(string: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n居中、局左、居右")
        
        let viewModel1 = ScableImageViewModel(location: text.length, image: #imageLiteral(resourceName: "bg2"), bounds: CGRect(origin: .zero, size: CGSize(width: 200, height: 200)))
        let view1 = scableImageView(viewModel: viewModel1)
        view1.backgroundColor = .clear
        view1.delegate = self
        text = text
            .insertingAttachment(SubviewTextAttachment(view: view1, size: view1.size), at: viewModel1.location, with: viewModel1.paraStyle)
        
        let mu = NSMutableAttributedString(attributedString: text)
        mu.insert(NSAttributedString(string: "\n还可以手动调节图片的大小\n\n"), at: mu.length)
        text = mu
        
        let viewModel2 = ScableImageViewModel(location: text.length, image: #imageLiteral(resourceName: "bg2"), bounds: CGRect(origin: .zero, size: CGSize(width: 200, height: 200)))
        let view2 = scableImageView(viewModel: viewModel2)
        view2.backgroundColor = .clear
        view2.delegate = self
        text = text
            .insertingAttachment(SubviewTextAttachment(view: view2, size: view2.size), at: viewModel2.location, with: viewModel2.paraStyle)
        
        let model3 = ScableImageModel(location: text.length, imageData: UIImage(named: "bg")!.pngData()!, bounds: "0,0,200,200", paraStyle: 0,contentMode: 2)
        let viewModel33 = ScableImageViewModel(model: model3)
        let model33 = viewModel33.getModel()
        let viewModel3 = ScableImageViewModel(model: model33)
        let view3 = scableImageView(viewModel: viewModel3)
        view3.backgroundColor = .clear
        view3.delegate = self
        text = text
            .insertingAttachment(SubviewTextAttachment(view: view3, size: view3.size), at: viewModel3.location, with: viewModel3.paraStyle)
        

        // Add attachments to the string and set it on the text view
        // This example avoids evaluating the attachments or attributed strings with attachments in the Playground because Xcode crashes trying to decode attachment objects
        textView.attributedText = text
    }
    

}

extension ViewController : scableImageViewDelegate{
    func reloadScableImage(endView:scableImageView){
        
        let newViewModel = endView.viewModel
        newViewModel.bounds = endView.frame
        newViewModel.getNewestLocation(attributedString: textView.attributedText){
            let newView = scableImageView(viewModel: newViewModel)
            newView.delegate = self
            newView.backgroundColor = .clear
            let newAttchment = SubviewTextAttachment(view: newView, size: newView.size)
            
            let mutable = NSMutableAttributedString(attributedString: textView.attributedText!)
            print("newView.model.location : \(newViewModel.location)")
            mutable.replaceAttchment(newAttchment, attchmentAt: newViewModel.location, with: newViewModel.paraStyle)
            textView.attributedText = mutable
            textView.selectedRange = NSRange(location: newViewModel.location, length: 0)
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
