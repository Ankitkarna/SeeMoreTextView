//
//  SeeMoreTextView.swift
//  SeeMoreTextView
//
//  Created by Ankit Karna on 4/24/20.
//  Copyright © 2020 Ankit Karna. All rights reserved.
//

import UIKit

public class SeeMoreTextView: UITextView {
    public var maximumNumberOfLines: Int = 3 {
        didSet {
            textContainer.maximumNumberOfLines = maximumNumberOfLines
        }
    }
    
    public var attributedSeeMoreText: NSMutableAttributedString!
   
    public var isToggleAnimated = true
    
    private let seeMoreTextStorage = SeeMoreTextStorage()
    
    private var originalText: NSMutableAttributedString!
    
    override public var font: UIFont? {
        didSet {
            if let font = font {
                originalText.addAttribute(.font, value: font, range: NSRange(location: 0, length: originalText.length))
                attributedSeeMoreText.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedSeeMoreText.length))
                
                seeMoreTextStorage.addAttribute(.font, value: font, range: NSRange(location: 0, length: seeMoreTextStorage.string.length))
            }
        }
    }
    
    override public var textColor: UIColor? {
        didSet {
            if let textColor = textColor {
                originalText.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: originalText.length))
                 seeMoreTextStorage.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: seeMoreTextStorage.string.length))
            }
        }
    }
    
    override public var text: String! {
        didSet {
            var attributes: [NSAttributedString.Key: Any] = [:]
            if let font = font { attributes[.font] = font }
            if let textColor = textColor { attributes[.foregroundColor] = textColor }
            originalText = NSMutableAttributedString(string: text, attributes: attributes)
            
            seeMoreTextStorage.replaceCharacters(in: NSRange(location: 0, length: seeMoreTextStorage.length), with: originalText)
        }
    }
    
    private var isTextTrimmed: Bool {
        let textContainerLength = layoutManager.characterRangeThatFits(textContainer: textContainer).length
        let originalTextLength = originalText.string.length
        return textContainerLength < originalTextLength
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if isTextTrimmed {
            addSeeMoreLabel()
        }
    }
    
    private func setupUI() {
        textStorage.removeLayoutManager(layoutManager)
        seeMoreTextStorage.addLayoutManager(layoutManager)
        isScrollEnabled = false
        isEditable = false
        textContainer.lineFragmentPadding = 0
        textContainerInset = .zero
        textContainer.maximumNumberOfLines = maximumNumberOfLines
        
        let defaultReadMoreText = "See More"
        let attributedReadMoreText = NSMutableAttributedString(string: "... ")
        
        let attributedDefaultReadMoreText = NSAttributedString(string: defaultReadMoreText, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 14)
        ])
        attributedReadMoreText.append(attributedDefaultReadMoreText)
        self.attributedSeeMoreText = attributedReadMoreText
        
        addGestures()
    }
    
    private func addGestures() {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textViewTapped))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func textViewTapped() {
       toggleSeeMoreLabel()
    }
    
    private func toggleSeeMoreLabel() {
        if isTextTrimmed {
            textContainer.maximumNumberOfLines = 0
            removeSeeMoreLabelIfAny()
        } else {
            textContainer.maximumNumberOfLines = maximumNumberOfLines
        }
        invalidateIntrinsicContentSize()
    }
    
    private func addSeeMoreLabel() {
        let range = rangeToReplaceWithReadMoreText()
        guard range.location != NSNotFound else { return }
        seeMoreTextStorage.replaceCharacters(in: range, with: attributedSeeMoreText)
    }
    
    private func removeSeeMoreLabelIfAny() {
        let originalTextRange = NSRange(location: 0, length: seeMoreTextStorage.length)
        seeMoreTextStorage.replaceCharacters(in: originalTextRange, with: originalText)
    }
    
    private func rangeToReplaceWithReadMoreText() -> NSRange {
        let rangeThatFitsContainer = layoutManager.characterRangeThatFits(textContainer: textContainer)
        if NSMaxRange(rangeThatFitsContainer) == originalText.string.length {
            return NSMakeRange(NSNotFound, 0)
        }
        else {
            let lastCharacterIndex = characterIndexBeforeTrim(range: rangeThatFitsContainer)
            if lastCharacterIndex > 0 {
                return NSMakeRange(lastCharacterIndex, seeMoreTextStorage.string.length - lastCharacterIndex)
            }
            else {
                return NSMakeRange(NSNotFound, 0)
            }
        }
    }
    
    private func characterIndexBeforeTrim(range rangeThatFits: NSRange) -> Int {
        let readMoreSize = attributedSeeMoreText.size()
        let lastCharacterRect = layoutManager.boundingRectForCharacterRange(range: NSMakeRange(NSMaxRange(rangeThatFits)-1, 1), inTextContainer: textContainer)
        var point = lastCharacterRect.origin
        point.x = textContainer.size.width - ceil(readMoreSize.width)
        let characterIndex = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return characterIndex - 1
    }
}
