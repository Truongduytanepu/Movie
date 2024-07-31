//
//  StringExtension.swift
//  Calculator
//
//  Created by Trịnh Xuân Minh on 09/09/2021.
//

import Foundation
import UIKit

public extension String {
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
    
    func heightText(width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let text: String = self
        return text.boundingRect(with: maxSize,
                                 options: .usesLineFragmentOrigin,
                                 attributes: [.font: font],
                                 context: nil).height + 1
    }
    
    func widthText(height: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: CGFloat(MAXFLOAT), height: height)
        let text: String = self
        return text.boundingRect(with: maxSize,
                                 options: .usesLineFragmentOrigin,
                                 attributes: [.font: font],
                                 context: nil).width + 1
    }
    
    func hexStringFromInt() -> Int {
        return Int(self, radix: 16) ?? 0
    }
    
    func getCleanedURL() -> URL? {
        guard !self.isEmpty else {
            return nil
        }
        if let url = URL(string: self) {
            return url
        } else if let urlEscapedString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
                  let escapedURL = URL(string: urlEscapedString) {
            return escapedURL
        }
        return nil
    }
    
    func trimmingAllSpaces(using characterSet: CharacterSet = .whitespacesAndNewlines) -> String {
        return components(separatedBy: characterSet).joined()
    }
    
    func heightForView(font: UIFont, width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.height + 10
    }
    
    func numberOfLines(forWidth width: CGFloat, font: UIFont) -> Int {
        let textStorage = NSTextStorage(string: self)
        let textContainer = NSTextContainer(size: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        let layoutManager = NSLayoutManager()
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textStorage.addAttribute(.font, value: font, range: NSRange(location: 0, length: textStorage.length))
        
        var numberOfLines = 0
        var index = 0
        var lineRange = NSRange()
        
        while index < textStorage.length {
            numberOfLines += 1
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
        }
        
        return numberOfLines
    }
}
