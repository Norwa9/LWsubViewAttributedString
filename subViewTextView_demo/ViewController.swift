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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(save))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(load))
        
        initUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func initUI(){
        //==============
        
        var text = NSAttributedString(string: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n居中、局左、居右")
        
        let viewModel1 = ScalableImageViewModel(location: text.length, image: #imageLiteral(resourceName: "bg2"), bounds: CGRect(origin: .zero, size: CGSize(width: 200, height: 200)))
        let view1 = ScalableImageView(viewModel: viewModel1)
        view1.backgroundColor = .clear
        view1.delegate = self
        text = text
            .insertingAttachment(SubviewTextAttachment(view: view1, size: view1.size), at: viewModel1.location, with: viewModel1.paraStyle)
        
        let mu = NSMutableAttributedString(attributedString: text)
        mu.insert(NSAttributedString(string: "\n还可以手动调节图片的大小\n\n"), at: mu.length)
        text = mu
        
        let viewModel2 = ScalableImageViewModel(location: text.length, image: #imageLiteral(resourceName: "bg2"), bounds: CGRect(origin: .zero, size: CGSize(width: 200, height: 200)))
        let view2 = ScalableImageView(viewModel: viewModel2)
        view2.backgroundColor = .clear
        view2.delegate = self
        text = text
            .insertingAttachment(SubviewTextAttachment(view: view2, size: view2.size), at: viewModel2.location, with: viewModel2.paraStyle)
        
        let model3 = ScalableImageModel(location: text.length, image: UIImage(named: "bg")!, bounds: "0,0,200,200", paraStyle: 0,contentMode: 2)
        let viewModel33 = ScalableImageViewModel(model: model3)
        let model33 = viewModel33.generateModel()
        let viewModel3 = ScalableImageViewModel(model: model33)
        let view3 = ScalableImageView(viewModel: viewModel3)
        view3.backgroundColor = .clear
        view3.delegate = self
        text = text
            .insertingAttachment(SubviewTextAttachment(view: view3, size: view3.size), at: viewModel3.location, with: viewModel3.paraStyle)
        

        // Add attachments to the string and set it on the text view
        // This example avoids evaluating the attachments or attributed strings with attachments in the Playground because Xcode crashes trying to decode attachment objects
        textView.attributedText = text
    }
    
    @objc func save(){
        let aString = textView.attributedText!
        let range = NSRange(location: 0, length: aString.length)
        var models:[ScalableImageModel] = []
        aString.enumerateAttribute(.attachment, in: range, options: []) { (object, range, stop) in
            if let attchment = object as? SubviewTextAttachment{
                if let view = attchment.view as? ScalableImageView{
                    let newestLocation = range.location
                    let viewModel = view.viewModel
                    viewModel.location = newestLocation
                    models.append(viewModel.generateModel())
                }
            }
        }
        
        saveAttributes(models: models)
        saveAttributedString(id_string: "2", aString: aString)
        print("save aString length : \(aString.length)")
    }
    
    @objc func load(){
        let models = loadAttributes()
        if let aString = loadAttributedString(id_string: "2"){
            textView.attributedText = recoverAttributedString(models: models, aString: aString)
        }
    }
    
    //MARK:-recover
    func recoverAttributedString(models:[ScalableImageModel],aString:NSAttributedString)->NSAttributedString{
        var result = aString
        for model in models{
            let viewModel = ScalableImageViewModel(model: model)
            let view = ScalableImageView(viewModel: viewModel)
            view.delegate = self
            let subViewAttributedString = SubviewTextAttachment(view: view, size: view.bounds.size)
            result = result.insertingAttachment(subViewAttributedString, at: viewModel.location,with: viewModel.paraStyle)
        }
        return result
    }

}

extension ViewController : scalableImageViewDelegate{
    func reloadScableImage(endView:ScalableImageView){
        let newViewModel = endView.viewModel
        newViewModel.bounds = endView.frame
        newViewModel.getNewestLocation(attributedString: textView.attributedText){
            let newView = ScalableImageView(viewModel: newViewModel)
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
    
}


