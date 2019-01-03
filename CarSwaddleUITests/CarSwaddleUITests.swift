//
//  CarSwaddleUITests.swift
//  CarSwaddleUITests
//
//  Created by Kyle Kendall on 9/20/18.
//  Copyright © 2018 CarSwaddle. All rights reserved.
//

import XCTest
@testable import CarSwaddleUI

class CarSwaddleUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateView() {
        let r = RandoView.viewFromNib()
        
        let v = CustomAlertContentView.view(withTitle: "Title", message: "Message")
        v.addCancelAction()
        
        let confirmAction = CustomAlertAction(title: "Confirm") { [weak self] action in
            print("confirm dat")
        }
        
        v.addAction(confirmAction)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
