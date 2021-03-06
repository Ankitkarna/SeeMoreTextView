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
    public var onSizeChange: (() -> Void)?
   
    private var originalStringText: NSMutableAttributedString?
    private var originalAttributedText: NSAttributedString?
    
    private var originalText: NSAttributedString? {
        if let attributedText = originalAttributedText {
            return attributedText
        } else if let text = originalStringText {
            return text
        }
        return nil
    }
    
    
    override public var font: UIFont? {
        didSet {
            if let font = font {
                if let originalText = originalStringText {
                     originalText.addAttribute(.font, value: font, range: NSRange(location: 0, length: originalText.length))
                }
               
                attributedSeeMoreText.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedSeeMoreText.length))
            }
        }
    }
    
    override public var textColor: UIColor? {
        didSet {
            if let textColor = textColor {
                if let originalText = originalStringText {
                    originalText.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: originalText.length))
                }
            }
        }
    }
    
    override public var text: String! {
        didSet {
            var attributes: [NSAttributedString.Key: Any] = [:]
            if let font = font { attributes[.font] = font }
            if let textColor = textColor { attributes[.foregroundColor] = textColor }
            originalStringText = NSMutableAttributedString(string: text, attributes: attributes)
            originalAttributedText = nil
        }
    }
    
    public override var attributedText: NSAttributedString! {
        didSet {
            originalAttributedText = attributedText
            originalStringText = nil
        }
    }
    
    private var isTextTrimmed: Bool {
        let textContainerLength = layoutManager.characterRangeThatFits(textContainer: textContainer).length
        guard let originalText = originalText else { return false }
        let originalTextLength = originalText.string.length
        if textContainerLength < originalTextLength {
            return true
        } else if textStorage.string != originalText.string {
            return true
        }
        return false
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
        isScrollEnabled = false
        isEditable = false
        textContainer.lineFragmentPadding = 0
        textContainerInset = .zero
        textContainer.maximumNumberOfLines = maximumNumberOfLines
        layoutManager.allowsNonContiguousLayout = false
        
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
        invalidateLayoutManager()
        if isTextTrimmed {
            textContainer.maximumNumberOfLines = 0
            removeSeeMoreLabelIfAny()
        } else {
            textContainer.maximumNumberOfLines = maximumNumberOfLines
        }
        invalidateLayout()
    }
    
    private func invalidateLayout() {
        invalidateIntrinsicContentSize()
        onSizeChange?()
    }
    
    private func invalidateLayoutManager() {
        let charRange = layoutManager.characterRangeThatFits(textContainer: textContainer)
        layoutManager.invalidateLayout(forCharacterRange: charRange, actualCharacterRange: nil)
        textContainer.size = CGSize(width: bounds.size.width, height: CGFloat.greatestFiniteMagnitude)
    }
    
    private func addSeeMoreLabel() {
        let range = rangeToReplaceWithReadMoreText()
        guard range.location != NSNotFound else { return }
        textStorage.replaceCharacters(in: range, with: attributedSeeMoreText)
    }
    
    private func removeSeeMoreLabelIfAny() {
        let originalTextRange = NSRange(location: 0, length: textStorage.string.length)
        textStorage.replaceCharacters(in: originalTextRange, with: originalText!)
    }
    
    private func rangeToReplaceWithReadMoreText() -> NSRange {
        let rangeThatFitsContainer = layoutManager.characterRangeThatFits(textContainer: textContainer)
        if textStorage.string != originalText!.string { //see more is already added
            return NSMakeRange(NSNotFound, 0)
        } else if NSMaxRange(rangeThatFitsContainer) == originalText!.string.length {
            return NSMakeRange(NSNotFound, 0)
        } else {
            let lastCharacterIndex = characterIndexBeforeTrim(range: rangeThatFitsContainer)
            if lastCharacterIndex > 0 {
                return NSMakeRange(lastCharacterIndex, textStorage.string.length - lastCharacterIndex)
            } else {
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
