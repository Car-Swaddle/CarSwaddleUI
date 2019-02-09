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
        delegate?.codeDidChange(code: code, viewController: self)
        guard let index = allTextFields.firstIndex(of: textField)?.advanced(by: 1),
            index < allTextFields.count else { return }
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
        for (index, c) in string.enumerated() {
            if index < allTextFields.count {
                let textField = allTextFields[index]
                textField.text = String(c)
            }
        }
        return true
    }
    
}

extension OneTimeCodeViewController: DeletingTextFieldDelegate {
    
    public func didDeleteBackward(_ textField: DeletingTextField) {
        guard let index = allTextFields.firstIndex(of: textField)?.advanced(by: -1),
            index >= 0 else { return }
        allTextFields[index].becomeFirstResponder()
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
