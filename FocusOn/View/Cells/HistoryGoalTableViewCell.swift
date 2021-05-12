//
//  HistoryGoalTableViewCell.swift
//  FocusOn
//
//  Created by James Tapping on 14/04/2021.
//

import UIKit

class HistoryGoalTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var name: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
