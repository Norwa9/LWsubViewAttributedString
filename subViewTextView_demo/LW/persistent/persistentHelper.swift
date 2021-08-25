//
//  persistentHelper.swift
//  subViewTextView_demo
//
//  Created by yy on 2021/8/25.
//

import Foundation

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
