//
//  DeclarativeUI.swift
//  FloatingTextfield
//
//  Created by Aybek Can Kaya on 29.07.2021.
//

import Foundation
import UIKit

// MARK: - UIView {View Factory}
extension UIView {
    public static func view() -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

// MARK: - UIStackView {View Factory}
extension UIStackView {
    public static func stackView(alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat, axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = alignment
        stack.distribution = distribution
        stack.spacing = spacing
        stack.axis = axis
        return stack
    }
}

// MARK: - UIImageView {View Factory}
extension UIImageView {
    public static func imageView() -> UIImageView {
        let imView = UIImageView(frame: .zero)
        imView.translatesAutoresizingMaskIntoConstraints = false
        return imView
    }
}

// MARK: - UICollectionView {View Factory}
extension UICollectionView {
    public static func collectionView(layout: UICollectionViewLayout) -> UICollectionView {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }
}

// MARK: - UILabel {View Factory}
extension UILabel {
    public static func label() -> UILabel {
        let lbl = UILabel(frame: .zero)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }
}

// MARK: - UITableView {View Factory}
extension UITableView {
    public static func tableView() -> UITableView {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }
}

// MARK: - UIButton {View Factory}
extension UIButton {
    public static func button() -> UIButton {
        let btn = UIButton(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }
}

// MARK: - UITextfield {View Factory}
extension UITextField {
    public static func textfield() -> UITextField {
        let tf = UITextField(frame: .zero)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }
}

// MARK: - UITextview {View Factory}
extension UITextView {
    public static func textview() -> UITextView {
        let tv = UITextView(frame: .zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }
}

// MARK: - UISlider {View Factory}
extension UISlider {
    public static func slider() -> UISlider {
        let tv = UISlider(frame: .zero)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }
}

// MARK: - UIView
extension UIView {
    @discardableResult
    public func roundCorners(by value: CGFloat, maskToBounds: Bool = false) -> UIView {
        self.layer.cornerRadius = value
        self.layer.masksToBounds = maskToBounds
        return self
    }
    
    @discardableResult
    public func shadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) -> UIView {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shouldRasterize = true
        self.layer.masksToBounds = false
        return self
    }
    
    @discardableResult
    public func backgroundColor(_ color: UIColor) -> UIView {
        self.backgroundColor = color
        return self
    }
}

// MARK: - Casting
extension UIView {
    public func asSlider() -> UISlider {
        return self as! UISlider
    }
    
    public func asStackView() -> UIStackView {
        return self as! UIStackView
    }
    
    public func asImageView() -> UIImageView {
        return self as! UIImageView
    }
    
    public func asCollectionView() -> UICollectionView {
        return self as! UICollectionView
    }
    
    public func asLabel() -> UILabel {
        return self as! UILabel
    }
    
    public func asTableView() -> UITableView {
        return self as! UITableView
    }
    
    public func asButton() -> UIButton {
        return self as! UIButton
    }
    
    public func asTextfield() -> UITextField {
        return self as! UITextField
    }
    
    public func asTextView() -> UITextView {
        return self as! UITextView
    }
}

// MARK: - Slider
extension UISlider {
    @discardableResult
    func minValue(_ value: Float) -> UISlider {
        self.minimumValue = value
        return self
    }
    
    @discardableResult
    func maxValue(_ value: Float) -> UISlider {
        self.maximumValue = value
        return self
    }
    
    @discardableResult
    func isContinuous(_ value: Bool) -> UISlider {
        self.isContinuous = value
        return self
    }
    
    @discardableResult
    func minTrackColor(_ value: UIColor) -> UISlider {
        self.minimumTrackTintColor = value
        return self
    }
    
    @discardableResult
    func maxTrackColor(_ value: UIColor) -> UISlider {
        self.maximumTrackTintColor = value
        return self
    }

}

// MARK: - CALayer
extension CALayer {
    public static func gradientLayer(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint ) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.colors = colors.map { $0.cgColor }
        return gradient
    }
    
    @discardableResult
    public func roundCorners(by value: CGFloat) -> CALayer {
        self.cornerRadius = value
        return self
    }
    
    @discardableResult
    public func asGradientLayer() -> CAGradientLayer {
        return self as! CAGradientLayer
    }
}

// MARK: - UIImageView
extension UIImageView {
    @discardableResult
    public func contentMode(_ mode: UIView.ContentMode) -> UIImageView {
        self.contentMode = mode
        return self 
    }
}

// MARK: UILabel
extension UILabel {
    @discardableResult
    public func font(_ font: UIFont) -> UILabel{
        self.font = font
        return self
    }
    
    @discardableResult
    public func textColor(_ color: UIColor) -> UILabel {
        self.textColor = color
        return self
    }
    
    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> UILabel {
        self.textAlignment = alignment
        return self
    }
    
    @discardableResult
    public func numberOfLines(_ count: Int) -> UILabel {
        self.numberOfLines = count
        return self
    }
}

// MARK: - UIButton
extension UIButton {
    @discardableResult
    public func contentEdgeInsets(_ edges: UIEdgeInsets) -> UIButton {
        self.contentEdgeInsets = edges
        return self
    }
    
    @discardableResult
    public func titleFont(_ font: UIFont) -> UIButton {
        self.titleLabel?.font = font
        return self
    }
    
    @discardableResult
    public  func titleColor(_ color: UIColor) -> UIButton {
        self.setTitleColor(color, for: .normal)
        return self
    }
}

// MARK: - UITableView
extension UITableView {
    @discardableResult
    public func contentInset(_ inset: UIEdgeInsets) -> UITableView {
        self.contentInset = inset
        return self
    }
    
    @discardableResult
    public  func seperatorStyle(_ style: UITableViewCell.SeparatorStyle) -> UITableView {
        self.separatorStyle = style
        return self
    }
    
    @discardableResult
    public  func registerCell(_ cell: AnyClass, identifier: String) -> UITableView {
        self.register(cell, forCellReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    public  func removeEmptyCellSeperators() -> UITableView {
        self.tableFooterView = UIView(frame: .zero)
        return self
    }
    
    @discardableResult
    public  func showsVerticalScrollIndicators(_ show: Bool) -> UITableView {
        self.showsVerticalScrollIndicator = show
        return self
    }
    
    @discardableResult
    public func showsHorizontalScrollIndicators(_ show: Bool) -> UITableView {
        self.showsHorizontalScrollIndicator = show
        return self
    }
}

// MARK: - UICollectionView
extension UICollectionView {
    @discardableResult
    public func contentInset(_ inset: UIEdgeInsets) -> UICollectionView {
        self.contentInset = inset
        return self
    }
}

// MARK: - UITextField
extension UITextField {
    @discardableResult
    public func placeholder(_ text: String) -> UITextField {
        self.placeholder = text
        return self
    }
    
    @discardableResult
    public func borderStyle(_ style: UITextField.BorderStyle) -> UITextField {
        self.borderStyle = style
        return self
    }
    
    @discardableResult
    public func font(_ font: UIFont) -> UITextField {
        self.font = font
        return self
    }
    
    @discardableResult
    public func autoCorrectionType(_ type: UITextAutocorrectionType) -> UITextField {
        self.autocorrectionType = type
        return self
    }
    
    @discardableResult
    public func autoCapitalizationType(_ type: UITextAutocapitalizationType) -> UITextField {
        self.autocapitalizationType = type
        return self
    }
    
    @discardableResult
    public func contentType(_ type: UITextContentType) -> UITextField {
        self.textContentType = type
        return self
    }
    
    @discardableResult
    public func spellCheckingType(_ type: UITextSpellCheckingType) -> UITextField {
        self.spellCheckingType = type
        return self
    }
    
    @discardableResult
    public func keyboardType(_ type: UIKeyboardType) -> UITextField {
        self.keyboardType = type
        return self
    }
    
    @discardableResult
    public func returnKey(_ type: UIReturnKeyType) -> UITextField {
        self.returnKeyType = type
        return self
    }
    
    @discardableResult
    public func secureTextEntry(_ isEnabled: Bool) -> UITextField {
        self.isSecureTextEntry = isEnabled
        return self
    }
}

// MARK: - UITextView
extension UITextView {
    @discardableResult
    public func textColor(_ color: UIColor) -> UITextView {
        self.textColor = color
        return self
    }
    
    @discardableResult
    public func font(_ font: UIFont) -> UITextView {
        self.font = font
        return self
    }
    
    @discardableResult
    public func autoCorrectionType(_ type: UITextAutocorrectionType) -> UITextView {
        self.autocorrectionType = type
        return self
    }
    
    @discardableResult
    public func autoCapitalizationType(_ type: UITextAutocapitalizationType) -> UITextView {
        self.autocapitalizationType = type
        return self
    }
    
    @discardableResult
    public func contentType(_ type: UITextContentType) -> UITextView {
        self.textContentType = type
        return self
    }
    
    @discardableResult
    public func spellCheckingType(_ type: UITextSpellCheckingType) -> UITextView {
        self.spellCheckingType = type
        return self
    }
    
    @discardableResult
    public func keyboardType(_ type: UIKeyboardType) -> UITextView {
        self.keyboardType = type
        return self
    }
    
    @discardableResult
    public func keyboardAppearance(_ type: UIKeyboardAppearance) -> UITextView {
        self.keyboardAppearance = type
        return self
    }
    
    @discardableResult
    public func returnKey(_ type: UIReturnKeyType) -> UITextView {
        self.returnKeyType = type
        return self
    }
    
    @discardableResult
    public func secureTextEntry(_ isEnabled: Bool) -> UITextView {
        self.isSecureTextEntry = isEnabled
        return self
    }
    
    @discardableResult
    public func isEditable(_ isEditable: Bool) -> UITextView {
        self.isEditable = isEditable
        return self
    }
}


