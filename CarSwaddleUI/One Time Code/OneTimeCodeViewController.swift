//
//  OneTimeCodeViewController.swift
//  CarSwaddleUI
//
//  Created by Kyle Kendall on 2/9/19.
//  Copyright © 2019 CarSwaddle. All rights reserved.
//

import UIKit

public protocol OneTeimViewControllerDelegate: AnyObject {
    func codeDidChange( viewController: OneTeimViewController)
}

public final class OneTimeCodeViewController: UIViewController, StoryboardInstantiating {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction private func editingDidChange(_ textField: DeletingTextField) {
        
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
