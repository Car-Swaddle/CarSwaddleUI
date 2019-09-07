//
//  TableButtonPagingViewController.swift
//  CarSwaddleUI
//
//  Created by Kyle Kendall on 9/7/19.
//  Copyright © 2019 CarSwaddle. All rights reserved.
//

import UIKit

open class TableButtonPagingViewController: PagingTableViewController {
    
    public var adjuster: ContentInsetAdjuster? {
        didSet {
            adjuster?.positionActionButton()
        }
    }
    
    public lazy var actionButton: ActionButton = {
        let button = ActionButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(actionButton)
        
        adjuster = ContentInsetAdjuster(tableView: tableView, actionButton: actionButton)
        adjuster?.showActionButtonAboveKeyboard = true
        adjuster?.positionActionButton()
    }
    
}
