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
    let centerParagraphStyle = NSMutableParagraphStyle()
    
    
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
        // Make paragraph styles for attachments
        centerParagraphStyle.alignment = .center
        centerParagraphStyle.paragraphSpacing = 10
        centerParagraphStyle.paragraphSpacingBefore = 10

        let leftParagraphStyle = NSMutableParagraphStyle()
        leftParagraphStyle.alignment = .left
        leftParagraphStyle.paragraphSpacing = 10
        leftParagraphStyle.paragraphSpacingBefore = 10

        // Create an image view with a tap recognizer
        let imageView = UIImageView(image: #imageLiteral(resourceName: "bg"))
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handle(_:)))
        imageView.addGestureRecognizer(gestureRecognizer)

        // Create an activity indicator view
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .black
        spinner.hidesWhenStopped = false
        spinner.startAnimating()
        
        //==============
        
        let text = NSAttributedString(string: "测试\n\n\n\n\n\n\n\n")
        
        let view1Model = ScableImageModel(location: text.length, image: #imageLiteral(resourceName: "bg"), bounds: CGRect(origin: .zero, size: CGSize(width: 200, height: 200)))
        let view1 = scableImageView(model: view1Model)
        view1.backgroundColor = .black
        view1.delegate = self
        view1.addGestureRecognizer(gestureRecognizer)

        // Add attachments to the string and set it on the text view
        // This example avoids evaluating the attachments or attributed strings with attachments in the Playground because Xcode crashes trying to decode attachment objects
        textView.attributedText = text
            .insertingAttachment(SubviewTextAttachment(view: view1, size: view1.size), at: view1.model.location, with: centerParagraphStyle)
//            .insertingAttachment(SubviewTextAttachment(view: spinner), at: 200)
//            .insertingAttachment(SubviewTextAttachment(view: UISwitch()), at: 300)
//            .insertingAttachment(SubviewTextAttachment(view: UIDatePicker()), at: 500, with: centerParagraphStyle)
    }
    @objc func handle(_ sender: UIGestureRecognizer!) {
        print("tapped")
        saveAttributedString(id_string: "1", aString: textView.attributedText)
    }

}

extension ViewController : scableImageViewDelegate{
    func reloadScableImage(view:scableImageView){
        let endFrame = view.frame
        
        let newModel = view.model
        newModel.bounds = endFrame
        
        let newView = scableImageView(model: newModel)
        newView.delegate = self
        newView.backgroundColor = .gray
        let newAttchment = SubviewTextAttachment(view: newView, size: newView.size)
        
        let mutable = NSMutableAttributedString(attributedString: textView.attributedText!)
        mutable.replaceAttchment(newAttchment, at: newView.model.location, with: centerParagraphStyle)
        textView.attributedText = mutable

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
