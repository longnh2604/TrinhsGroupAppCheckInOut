//
//  DropDownSelectionTableViewCell.swift
//  Family App
//
//  Created by Work on 2020-09-15.
//  Copyright © 2020 CONNECT2D. All rights reserved.
//

import UIKit

class DropDownSelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var contentUIView: UIView!
    @IBOutlet weak var selection: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentUIView.layer.masksToBounds = true
//        contentUIView.layer.cornerRadius = 24
        contentUIView.layer.borderColor = UIColor.black.cgColor
        contentUIView.layer.borderWidth = 2
        
        selection.textColor = UIColor.blue
    }
}
