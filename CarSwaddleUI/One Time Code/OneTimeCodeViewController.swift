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

public final class OneTimeCodeViewController: UIViewController, StoryboardInstantiating {
    
    public weak var delegate: OneTimeCodeViewControllerDelegate?
    
    public var numberOfDigits: Int = 4 {
        didSet {
            oneTimeCodeEntryView.digits = numberOfDigits
        }
    }
    
    @IBOutlet public weak var verifyPhoneNumberTitleLabel: UILabel!
    @IBOutlet public weak var verifyPhoneNumberDescriptionLabel: UILabel!
    @IBOutlet public weak var resendCodeButton: UIButton!
    
    @IBOutlet private weak var oneTimeCodeEntryView: OneTimeCodeEntryView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        oneTimeCodeEntryView.digits = numberOfDigits
        oneTimeCodeEntryView.textFieldWidth = 70
    }
    
    @IBAction private func didSelectResendVerificationCode() {
        delegate?.didSelectResendVerificationCode(viewController: self)
    }
    
}

extension OneTimeCodeViewController: OneTimeEntryViewDelegate {
    
    public func configureTextField(textField: DeletingTextField, view: OneTimeCodeEntryView) {
        print("configure text field")
    }
    
    public func codeDidChange(code: String, view: OneTimeCodeEntryView) {
        delegate?.codeDidChange(code: code, viewController: self)
    }
    
}
