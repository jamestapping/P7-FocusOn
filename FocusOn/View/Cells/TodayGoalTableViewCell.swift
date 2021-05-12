//
//  TodayGoalTableViewCell.swift
//  FocusOn
//
//  Created by James Tapping on 15/03/2021.
//

import Foundation
import UIKit

protocol TodayGoalCellDelegate {
    func updateGoalCell(cell: TodayGoalTableViewCell)
    func updateGoalCellCompletion(cell: TodayGoalTableViewCell)
    func updateCellHeight()
}

class TodayGoalTableViewCell: UITableViewCell {
    
    var tempPlaceholder:String = ""
    var goalCompleted = false
    
    var delegate: TodayGoalCellDelegate?
    
    
    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var goalToggleButton: CheckMarkToggleButtonWhite!
    
    @IBAction func didTapGoalToggle(_ sender: CheckMarkToggleButtonWhite) {
        
        goalCompleted = !goalToggleButton.isSelected
        
        goalCompleted.toggle()
        
        goalCompleted ? goalTextView.strike(type: .single) : goalTextView.unstrike()
        
        delegate?.updateGoalCellCompletion(cell: self)
        
    }
    
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        goalTextView.isScrollEnabled = false
        goalTextView.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension TodayGoalTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
//        let size = CGSize(width: textView.frame.size.width, height: .infinity)
//        let estimatedSize = textView.sizeThatFits(size)
//        textView.frame.size.height = estimatedSize.height
        
        delegate?.updateCellHeight()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n"){
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "Set your goal..." {
            
            textView.text = ""
            
        }
        
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            
            textView.text = "Set your goal..."
            
        }
        
        delegate?.updateGoalCell(cell: self)
        
    }
    
    
}
    
