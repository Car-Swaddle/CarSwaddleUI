//
//  PocketViewController.swift
//  CarSwaddleUI
//
//  Created by Kyle Kendall on 3/23/19.
//  Copyright © 2019 CarSwaddle. All rights reserved.
//

import UIKit

public class PocketController: UINavigationController {
    
    public var bottomViewControllerHeight: CGFloat = 100 {
        didSet {
            updateBottomViewControllerHeight()
            updateAdditionalSafeAreaInsets()
        }
    }
    
    public var effectStyle: UIBlurEffect.Style = .light {
        didSet {
            blurView.effect = blurEffect
        }
    }
    
    public init(rootViewController: UIViewController, bottomViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.bottomViewController = bottomViewController
        self.addBottomViewControllerIfNeeded()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public var bottomViewController: UIViewController? {
        didSet {
            if let oldValue = oldValue {
                oldValue.willMove(toParent: nil)
                oldValue.view.removeFromSuperview()
                oldValue.removeFromParent()
            } else {
                addBottomViewControllerIfNeeded()
            }
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        addBottomContainerViewControllerIfNeeded()
    }
    
    public override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        if view.safeAreaInsets.bottom != suggestedSafeAreaInsetBottom {
            updateAdditionalSafeAreaInsets()
        }
        updateBottomViewControllerHeight()
    }
    
    public override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return true
    }
    
    private func updateAdditionalSafeAreaInsets() {
        additionalSafeAreaInsets = suggestedAdditionalSafeAreaInsets
    }
    
    private var suggestedAdditionalSafeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: suggestedSafeAreaInsetBottom, right: 0)
    }
    
    private var suggestedSafeAreaInsetBottom: CGFloat {
        return bottomViewControllerHeight - safeAreaInsetsMinusAdditional.bottom
    }
    
    private func updateBottomViewControllerHeight() {
        heightConstraint?.constant = bottomViewControllerHeight + view.safeAreaInsets.bottom
    }
    
    private var heightConstraint: NSLayoutConstraint?
    
    private lazy var bottomContainerViewController: UIViewController = {
        let bottomContainerViewController = UIViewController()
        bottomContainerViewController.view.backgroundColor = .white
        return bottomContainerViewController
    }()
    
    private func addBottomContainerViewControllerIfNeeded() {
        guard bottomContainerViewController.parent == nil else { return }
        addChild(bottomContainerViewController)
        
        bottomContainerViewController.view.layer.shadowOpacity = 0.2
        
        view.addSubview(bottomContainerViewController.view)
        
        bottomContainerViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let c = bottomContainerViewController.view.heightAnchor.constraint(equalToConstant: bottomViewControllerHeight)
        c.isActive = true
        heightConstraint = c
        
        bottomContainerViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bottomContainerViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomContainerViewController.didMove(toParent: self)
        bottomContainerViewController.view.backgroundColor = .clear
        
        bottomContainerViewController.view.addSubview(blurView)
        blurView.pinFrameToSuperViewBounds()
    }
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
    }()
    
    private var blurEffect: UIBlurEffect {
        return UIBlurEffect(style: effectStyle)
    }
    
    private func addBottomViewControllerIfNeeded() {
        guard let bottomViewController = bottomViewController else { return }
        bottomContainerViewController.addChild(bottomViewController)
        
        bottomContainerViewController.view.addSubview(bottomViewController.view)
        
        bottomViewController.view.translatesAutoresizingMaskIntoConstraints = false
        bottomViewController.view.pinFrameToSuperViewBounds()
        bottomViewController.didMove(toParent: self)
        
        bottomViewControllerHeight = bottomViewController.view.intrinsicContentSize.height
    }
    
}


public extension UIViewController {
    
    public var safeAreaInsetsMinusAdditional: UIEdgeInsets {
        return UIEdgeInsets(top: view.safeAreaInsets.top - additionalSafeAreaInsets.top,
                            left: view.safeAreaInsets.left - additionalSafeAreaInsets.left,
                            bottom: view.safeAreaInsets.bottom - additionalSafeAreaInsets.bottom,
                            right: view.safeAreaInsets.right - additionalSafeAreaInsets.right)
    }
    
}
