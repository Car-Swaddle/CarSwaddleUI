//
//  TableViewController.swift
//  CarSwaddleUI
//
//  Created by Kyle Kendall on 8/25/19.
//  Copyright © 2019 CarSwaddle. All rights reserved.
//

import UIKit


public protocol TableViewControllerRow {
    var identifier: String { get }
}

open class TableViewController: UIViewController, UITableViewDataSource {
    
    
    public init(schema: [Section]) {
        super.init(nibName: nil, bundle: nil)
        
        self.schema = schema
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public struct Section {
        let rows: [TableViewControllerRow]
        
        public init(rows: [TableViewControllerRow]) {
            self.rows = rows
        }
    }
    
    public func setSchema(newSchema: [Section], animated: Bool) {
        schema = newSchema
        // TODO: do that animation
    }
    
    open var schema: [Section] = []
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    public lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    private func setupTableView() {
        registerCells()
        
        view.addSubview(tableView)
        tableView.pinFrameToSuperViewBounds()
        tableView.tableFooterView = UIView()
    }
    
    open var cellTypes: [NibRegisterable.Type] = [] {
        didSet {
            registerCells()
        }
    }
    
    
    private func registerCells() {
        for cellType in cellTypes {
            tableView.register(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schema[section].rows.count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return schema.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(for: self.row(with: indexPath))
    }
    
    
    open func cell(for row: TableViewControllerRow) -> UITableViewCell {
        fatalError("Subclass must override")
    }
    
    private func row(with indexPath: IndexPath) -> TableViewControllerRow {
        return schema[indexPath.section].rows[indexPath.row]
    }
    
}

