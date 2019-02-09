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
    
    @IBInspectable private var spacing: CGFloat = 20 {
        didSet { stackView.spacing = spacing }
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
    
    @IBInspectable var digits: Int = 4 {
        didSet {
            updateStackViewWithTextFields()
        }
    }
    
    private func updateStackViewWithTextFields() {
        for textField in textFields {
            stackView.removeArrangedSubview(textField)
        }
        
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
        textField.font = UIFont.boldSystemFont(ofSize: 19)
        textField.layer.cornerRadius = 3
        textField.backgroundColor = .white
        
        textField.deleteDelegate = self
        
        textField.addTarget(self, action: #selector(OneTimeCodeEntryView.editingDidChange(_:)), for: .editingChanged)
        
        return textField
    }
    
    @objc private func editingDidChange(_ textField: DeletingTextField) {
        let textCount = textField.text?.count ?? 0
        let textCountIsMax = textCount == 4
        let textCountIs2 = textCount == 2
        
        if textCountIsMax {
            updateTextFieldsWith(string: textField.text ?? "")
            textFields.last?.becomeFirstResponder()
        }
        
        if textCountIs2, let last = textField.text?.last {
            textField.text = String(last)
        }
        
        delegate?.codeDidChange(code: code, view: self)
        guard let index = textFields.firstIndex(of: textField),
            index < textFields.count,
            textCountIsMax == false,
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
    
    private func updateTextFieldsWith(string: String) {
        for (index, c) in string.enumerated() {
            if index < textFields.count {
                let textField = textFields[index]
                textField.text = String(c)
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
