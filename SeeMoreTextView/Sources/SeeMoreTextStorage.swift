//
//  SeeMoreTextStorage.swift
//  SeeMoreTextView
//
//  Created by Ankit Karna on 4/24/20.
//  Copyright © 2020 Ankit Karna. All rights reserved.
//

import UIKit

class SeeMoreTextStorage: NSTextStorage {
    private let stringValue = NSMutableAttributedString()
    
    override var string: String {
        return stringValue.string
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        return stringValue.attributes(at: location, effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        stringValue.replaceCharacters(in: range, with: str)
        edited(.editedCharacters, range: range, changeInLength: str.length - range.length)
    }
    
    override func replaceCharacters(in range: NSRange, with attrString: NSAttributedString) {
        stringValue.replaceCharacters(in: range, with: attrString)
        edited(.editedCharacters, range: range, changeInLength: attrString.length - range.length)
    }
    
    override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        stringValue.setAttributes(attrs, range: range)
        edited(.editedCharacters, range: range, changeInLength: 0)
    }
    
    override func processEditing() {
        super.processEditing()
    }
}


extension String {
    var length: Int {
        return utf16.count
    }
}
