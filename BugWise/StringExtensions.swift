//
//  StringExtensions.swift
//  BugWise
//
//  Created by olbu on 6/11/17.
//  Copyright © 2017 olbu. All rights reserved.
//

extension String {
    func stringFromHtml(textColor: UIColor = .black, font: UIFont? = nil) -> NSAttributedString? {
        do {
            
            var resultStr = self
            
            if let font = font {
                resultStr = String(format:"<span style=\"font-family: '\(font.familyName)', '\(font.fontName)'; font-size: \(font.pointSize)\">%@</span>", self)
            }
            
                       
            let data = resultStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
            if let d = data {
                let str: NSMutableAttributedString = try NSAttributedString(data: d,
                                                 options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                 documentAttributes: nil).mutableCopy() as! NSMutableAttributedString
                
                let fullRange = NSRange(location: 0, length: str.length)
                str.addAttribute(NSForegroundColorAttributeName, value: textColor, range: fullRange)
                
                return str.copy() as? NSAttributedString
            }
        } catch {
        }
        return nil
    }
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return self[Range(start ..< end)]
    }
    
    func highligtedString(_ searchedText: String?, defaultColor: UIColor? = nil, highlightedColor: UIColor? = nil, font: UIFont? = nil) -> NSAttributedString? {
        
        guard let highlightText = searchedText, (searchedText?.characters.count)! > 0 else { return NSAttributedString(string: self) }
        
        let range = (self.lowercased() as NSString).range(of: highlightText.lowercased())
        

        let attributedString = NSMutableAttributedString(string: self)
        
        let fullRange = NSRange(location: 0, length: attributedString.length)
        
        if let textColor = defaultColor {
            attributedString.addAttribute(NSForegroundColorAttributeName, value: textColor, range: fullRange)
        }
        
        attributedString.addAttribute(NSForegroundColorAttributeName, value: highlightedColor ?? CommonAppearance.lighBlueColor , range: range)
        
        if let textFont = font {
            attributedString.addAttribute(NSFontAttributeName, value: textFont, range: fullRange)
        }
        
        return attributedString
    }
    
    var containsOnlyNumberCharacter: Bool {
        guard let _ = self.number?.doubleValue else {
            return false
        }
        
        return true
    }
    
    var number: NSNumber? {
        return Number.numberFormatter.number(from: self)
    }
    
}
