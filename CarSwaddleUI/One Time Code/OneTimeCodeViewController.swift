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
    func didSelectResendVerificationCode(viewController: OneTimeCodeViewController)
}

open class OneTimeCodeViewController: UIViewController, StoryboardInstantiating {
    
    public weak var delegate: OneTimeCodeViewControllerDelegate?
    
    public var numberOfDigits: Int = 5 {
        didSet {
            oneTimeCodeEntryView.digits = numberOfDigits
        }
    }
    
    @IBOutlet public weak var verifyPhoneNumberTitleLabel: UILabel!
    @IBOutlet public weak var verifyPhoneNumberDescriptionLabel: UILabel!
    @IBOutlet public weak var resendCodeButton: UIButton!
    
    @IBOutlet private weak var oneTimeCodeEntryView: OneTimeCodeEntryView!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        oneTimeCodeEntryView.digits = numberOfDigits
        oneTimeCodeEntryView.textFieldWidth = 50
    }
    
    @IBAction private func didSelectResendVerificationCode() {
        delegate?.didSelectResendVerificationCode(viewController: self)
    }
    
}

extension OneTimeCodeViewController: OneTimeEntryViewDelegate {
    
    public func configureTextField(textField: DeletingTextField, view: OneTimeCodeEntryView) {
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowRadius = 3.0
        textField.layer.shadowOffset = CGSize(width: 1, height: 2)
    }
    
    public func codeDidChange(code: String, view: OneTimeCodeEntryView) {
        delegate?.codeDidChange(code: code, viewController: self)
    }
    
}
