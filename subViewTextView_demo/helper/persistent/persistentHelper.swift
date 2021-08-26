//
//  persistentHelper.swift
//  subViewTextView_demo
//
//  Created by yy on 2021/8/25.
//

import Foundation
import YYModel
//MARK:-save
func saveAttributes(models:[ScalableImageModel]){
    let jsonEncoder = JSONEncoder()
    if let modelsData = try? jsonEncoder.encode(models) {
        let fileName = "test.json"
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
           let fileURL = dir.appendingPathComponent(fileName)
            do {
                try modelsData.write(to: fileURL, options: .atomic)
            } catch {
                print(print("FileManager Failed to write models"))
            }
        }
    } else {
        print("Failed to Encode models")
    }
}

func saveAttributedString(id_string:String,aString:NSAttributedString?) {
        do {
            let file = try aString?.fileWrapper (
                from: NSMakeRange(0, aString!.length),
                documentAttributes: [.documentType: NSAttributedString.DocumentType.rtfd])
            
            if let dir = FileManager.default.urls (for: .documentDirectory, in: .userDomainMask) .first {
                let path_file_name = dir.appendingPathComponent (id_string)
                do {
                    try file!.write (to: path_file_name, options: .atomic, originalContentsURL: nil)
                } catch {
                    // Error handling
                }
            }
        } catch {
            //Error handling
        }
        
}

//MARK:-load
func loadAttributes() -> [ScalableImageModel]{
    let fileName = "test.json"
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
       let fileURL = dir.appendingPathComponent(fileName)
        do {
            let data = try Data(contentsOf: fileURL)
            if let models = NSArray.yy_modelArray(with: ScalableImageModel.self, json: data) as? [ScalableImageModel]{
                print("fileManager load models.count:\(models.count)")
                return models
            }
        } catch {
            print("error:\(error)")
            return []
        }
    }
    return []
}

func loadAttributedString(id_string:String) -> NSAttributedString?{
   if let dir = FileManager.default.urls (for: .documentDirectory, in: .userDomainMask) .first {
       let path_file_name = dir.appendingPathComponent (id_string)
       do{
           let aString = try NSAttributedString(
               url: path_file_name,
               options: [.documentType:NSAttributedString.DocumentType.rtfd],
               documentAttributes: nil)
           return aString
       }catch{
           //
       }
   }
   return nil
}



