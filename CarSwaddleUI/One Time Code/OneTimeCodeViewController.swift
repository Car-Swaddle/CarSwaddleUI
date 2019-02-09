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
        let textIsGreatherThan1 = (textField.text?.count ?? 0) > 1
        
        if textIsGreatherThan1 {
            updateCodeWith(string: textField.text ?? "")
            fourthLetterTextField.becomeFirstResponder()
        }
        delegate?.codeDidChange(code: code, viewController: self)
        guard let index = allTextFields.firstIndex(of: textField)?.advanced(by: 1),
            index < allTextFields.count,
            textIsGreatherThan1 == false else { return }
        allTextFields[index].becomeFirstResponder()
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
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.count > 1 else { return true }
        updateCodeWith(string: string)
        return true
    }
    
    private func updateCodeWith(string: String) {
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
