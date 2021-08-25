//
//  persistentHelper.swift
//  subViewTextView_demo
//
//  Created by yy on 2021/8/25.
//

import Foundation
//MARK:-save
func saveAttributes(models:[ScalableImageModel]){
    let defautls = UserDefaults.standard
    let jsonEncoder = JSONEncoder()
    if let modelsData = try? jsonEncoder.encode(models) {
        defautls.set(modelsData, forKey: "ScableImageModel")
    } else {
        print("Failed to save roamData")
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
    let defaults = UserDefaults.standard
    
    if let savedData = defaults.object(forKey: "ScableImageModel") as? Data {
        let jsonDecoder = JSONDecoder()
        do {
           let models = try jsonDecoder.decode([ScalableImageModel].self, from: savedData)
            return models
        } catch {

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



