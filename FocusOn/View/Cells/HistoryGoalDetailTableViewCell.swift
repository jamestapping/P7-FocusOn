//
//  HistoryGoalTableViewCell.swift
//  FocusOn
//
//  Created by James Tapping on 08/04/2021.
//

import UIKit

class HistoryGoalDetailTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var goalToggleButton: CheckMarkToggleButtonWhite!
    
    @IBOutlet weak var goalTextView: UITextView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
