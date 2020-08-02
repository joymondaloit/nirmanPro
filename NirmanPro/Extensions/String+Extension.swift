//
//  String+Extension.swift
//  NirmanPro
//
//  Created by Joy Mondal on 24/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import Foundation
import UIKit
extension StringProtocol  {
    var digits: [Int] { compactMap(\.wholeNumberValue) }
}
extension String {
    
        func strikeThrough() -> NSAttributedString {
            let attributeString =  NSMutableAttributedString(string: "₹"+self)
            attributeString.addAttribute(
                NSAttributedString.Key.strikethroughStyle,
                   value: NSUnderlineStyle.single.rawValue,
                       range:NSMakeRange(0,attributeString.length))
            return attributeString
        }
    
    private var convertHtmlToNSAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data,options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    public func convertHtmlToAttributedStringWithCSS(font: UIFont? , csscolor: String , lineheight: Int, csstextalign: String) -> NSAttributedString? {
        guard let font = font else {
            return convertHtmlToNSAttributedString
        }
        let modifiedString = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color: \(csscolor); line-height: \(lineheight)px; text-align: \(csstextalign); }</style>\(self)";
        guard let data = modifiedString.data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error)
            return nil
        }
    }
}
