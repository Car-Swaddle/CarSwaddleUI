//
//  OneTimeCodeEntryView.swift
//  CarSwaddleUI
//
//  Created by Kyle Kendall on 2/9/19.
//  Copyright © 2019 CarSwaddle. All rights reserved.
//

import UIKit

@objc public protocol OneTimeEntryViewDelegate: AnyObject {
    func codeDidChange(code: String, view: OneTimeCodeEntryView)
}

open class OneTimeCodeEntryView: UIView {
    
    @IBOutlet public weak var delegate: OneTimeEntryViewDelegate?
    
    @IBInspectable public var spacing: CGFloat = 20 {
        didSet { stackView.spacing = spacing }
    }
    
    @IBInspectable public var digits: Int = 4 {
        didSet { updateStackViewWithTextFields() }
    }
    
    @IBInspectable public var textFieldTintColor: UIColor? {
        didSet { updateStackViewWithTextFields() }
    }
    
    @IBInspectable public var textFieldBackgroundColor: UIColor = UIColor(hexString: "E7EBFF") {
        didSet { updateStackViewWithTextFields() }
    }
    
    @IBInspectable public var textFieldCornerRadius: CGFloat = 3 {
        didSet { updateStackViewWithTextFields() }
    }
    
    @IBInspectable public var textFieldFont: UIFont = UIFont.boldSystemFont(ofSize: 19) {
        didSet { updateStackViewWithTextFields() }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        addSubview(stackView)
        stackView.pinFrameToSuperViewBounds()
        updateStackViewWithTextFields()
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var textFields: [DeletingTextField] = []
    
    private func updateStackViewWithTextFields() {
        for textField in textFields {
            stackView.removeArrangedSubview(textField)
        }
        
        textFields.removeAll()
        
        for _ in 0..<digits {
            let textField = self.createTextField()
            stackView.addArrangedSubview(textField)
            textFields.append(textField)
        }
    }
    
    private func createTextField() -> DeletingTextField {
        let textField = DeletingTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textContentType = .oneTimeCode
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.smartDashesType = .no
        textField.smartQuotesType = .no
        textField.smartInsertDeleteType = .no
        textField.spellCheckingType = .no
        textField.keyboardType = .numberPad
        
        textField.textAlignment = .center
        textField.font = textFieldFont
        textField.layer.cornerRadius = textFieldCornerRadius
        textField.backgroundColor = textFieldBackgroundColor
        textField.tintColor = textFieldTintColor
        
        textField.adjustsFontSizeToFitWidth = true
        
        textField.deleteDelegate = self
        
        textField.addTarget(self, action: #selector(OneTimeCodeEntryView.editingDidChange(_:)), for: .editingChanged)
        
        return textField
    }
    
//    private var isChanging = false
    
    @objc private func editingDidChange(_ textField: DeletingTextField) {
//        if isChanging { return }
        let textCount = textField.text?.count ?? 0
        let textIsGreaterThan2 = textCount > 2
        let textCountIs2 = textCount == 2
        
        if textIsGreaterThan2 {
//            isChanging = true
            updateTextFieldsWith(string: textField.text ?? "")
//            isChanging = true
            textFields.last?.becomeFirstResponder()
        }
        
        if textCountIs2, let last = textField.text?.last {
            textField.text = String(last)
        }
        
        delegate?.codeDidChange(code: code, view: self)
        guard let index = textFields.firstIndex(of: textField),
            index < textFields.count,
            textIsGreaterThan2 == false,
            textFields[index].text?.isEmpty != true,
            index.advanced(by: 1) < textFields.count else { return }
        let nextIndex = index.advanced(by: 1)
        textFields[nextIndex].becomeFirstResponder()
    }
    
    private var code: String {
        var code = ""
        textFields.forEach { textField in
            code += textField.text ?? ""
        }
        return code
    }
    
}

extension OneTimeCodeEntryView: UITextFieldDelegate {
    
//    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        print("textField: \(String(describing: textField.text)), range: \(range), replacementString: \(string)")
//        return true
//    }
    
    private func updateTextFieldsWith(string: String) {
        
        textFields.forEach { $0.text = nil }
        
        for (index, c) in string.enumerated() {
            if index < textFields.count {
                textFields[index].text = String(c)
            }
        }
    }
    
}

extension OneTimeCodeEntryView: DeletingTextFieldDelegate {
    
    public func didDeleteBackward(_ textField: DeletingTextField) {
        guard let originalIndex = textFields.firstIndex(of: textField),
            originalIndex > 0 else { return }
        let previousIndex = originalIndex.advanced(by: -1)
        textFields[previousIndex].becomeFirstResponder()
    }
    
}
