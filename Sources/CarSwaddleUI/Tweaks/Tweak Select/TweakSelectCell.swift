//
//  TweakSelectCell.swift
//  CarSwaddleMechanic
//
//  Created by Kyle Kendall on 1/27/19.
//  Copyright © 2019 CarSwaddle. All rights reserved.
//

import UIKit

final class TweakSelectCell: UITableViewCell, NibRegisterable {
    
    @IBOutlet weak var tweakValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public static var bundle: Bundle {
        return Bundle.module
    }
    
}
