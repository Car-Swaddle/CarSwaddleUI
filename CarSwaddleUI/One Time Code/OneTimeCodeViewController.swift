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
        
        
    }
    
    
    @IBAction private func editingDidChange(_ textField: DeletingTextField) {
        delegate?.codeDidChange(code: code, viewController: self)
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
    
    
    
}

extension OneTimeCodeViewController: DeletingTextFieldDelegate {
    
    public func didDeleteBackward(_ textField: DeletingTextField) {
        print("delete backward")
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
