//
//  HIstoryTaskTableViewCell.swift
//  FocusOn
//
//  Created by James Tapping on 08/04/2021.
//

import UIKit

class HistoryTaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskTextView: UITextView!
    @IBOutlet weak var taskToggleButton: CheckMarkToggleButtonBlack!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
