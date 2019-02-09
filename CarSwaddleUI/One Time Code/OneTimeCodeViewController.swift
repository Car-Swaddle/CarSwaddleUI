//
//  OneTimeCodeViewController.swift
//  CarSwaddleUI
//
//  Created by Kyle Kendall on 2/9/19.
//  Copyright © 2019 CarSwaddle. All rights reserved.
//

import UIKit

public protocol OneTimeCodeViewControllerDelegate: AnyObject {
    func codeDidChange(code: String, viewController: OneTimeCodeViewController)
}

public final class OneTimeCodeViewController: UIViewController, StoryboardInstantiating {
    
    public weak var delegate: OneTimeCodeViewControllerDelegate?
    
    
    @IBOutlet public weak var oneTimeCodeEntryView: OneTimeCodeEntryView!
    
    @IBOutlet private weak var firstLetterTextField: DeletingTextField!
    @IBOutlet private weak var secondLetterTextField: DeletingTextField!
    @IBOutlet private weak var thirdLetterTextField: DeletingTextField!
    @IBOutlet private weak var fourthLetterTextField: DeletingTextField!
    
    private var allTextFields: [DeletingTextField] {
        return [firstLetterTextField, secondLetterTextField, thirdLetterTextField, fourthLetterTextField]
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFields()
    }
    
    private func setupTextFields() {
        for textField in allTextFields {
            textField.layer.cornerRadius = 3
        }
    }
    
    
    @IBAction private func editingDidChange(_ textField: DeletingTextField) {
        let textCount = textField.text?.count ?? 0
        let textCountIs4 = textCount == 4
        let textCountIs2 = textCount == 2
        
        
        if textCountIs4 {
            updateTextFieldsWith(string: textField.text ?? "")
            fourthLetterTextField.becomeFirstResponder()
        }
        
        if textCountIs2, let last = textField.text?.last {
            textField.text = String(last)
        }
        
        delegate?.codeDidChange(code: code, viewController: self)
        guard let index = allTextFields.firstIndex(of: textField),
            index < allTextFields.count,
            textCountIs4 == false,
            allTextFields[index].text?.isEmpty != true,
            index.advanced(by: 1) < allTextFields.count else { return }
        let nextIndex = index.advanced(by: 1)
        allTextFields[nextIndex].becomeFirstResponder()
    }
    
    private var code: String {
        var code = ""
        allTextFields.forEach { textField in
            code += textField.text ?? ""
        }
        return code
    }
    
}

extension OneTimeCodeViewController: UITextFieldDelegate {
    
    private func updateTextFieldsWith(string: String) {
        for (index, c) in string.enumerated() {
            if index < allTextFields.count {
                let textField = allTextFields[index]
                textField.text = String(c)
            }
        }
    }
    
}

extension OneTimeCodeViewController: DeletingTextFieldDelegate {
    
    public func didDeleteBackward(_ textField: DeletingTextField) {
        guard let originalIndex = allTextFields.firstIndex(of: textField),
            originalIndex > 0 else { return }
        let previousIndex = originalIndex.advanced(by: -1)
        allTextFields[previousIndex].becomeFirstResponder()
    }
    
}

extension OneTimeCodeViewController: OneTimeEntryViewDelegate {
    
    public func codeDidChange(code: String, view: OneTimeCodeEntryView) {
        print("bottom code change")
    }
    
}


@objc public protocol DeletingTextFieldDelegate: AnyObject {
    func didDeleteBackward(_ textField: DeletingTextField)
}

public final class DeletingTextField: UITextField {
    
    @IBOutlet public weak var deleteDelegate: DeletingTextFieldDelegate?
    
    public override func deleteBackward() {
        super.deleteBackward()
        deleteDelegate?.didDeleteBackward(self)
    }
    
}
