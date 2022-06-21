//
//  InOutCell.swift
//  TrinhsgroupCheckInOut
//
//  Created by longnh on 2022/05/10.
//

import UIKit

class InOutCell: UITableViewCell {

    @IBOutlet weak var lblNote: UILabel!
    var type: InOutRequest = .checkIn
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(data: InOutModel) {
        self.contentView.backgroundColor = data.type == InOutRequest.checkIn.rawValue ? .systemGreen : .systemRed
        lblNote.text = data.time ?? ""
    }
}
