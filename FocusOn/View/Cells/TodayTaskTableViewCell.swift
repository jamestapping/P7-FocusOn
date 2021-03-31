//
//  TodayTaskTableViewCell.swift
//  FocusOn
//
//  Created by James Tapping on 17/03/2021.
//

import UIKit

protocol TodayTaskCellDelegate {
    func updateTaskCell(cell: TodayTaskTableViewCell?, name: String)
    func updateTaskCell(cell: TodayTaskTableViewCell, completed: Bool)
    func createNewTask(cell: TodayTaskTableViewCell?)
    func updateCellHeight()
    func moveToBottomOfTableView(cell: TodayTaskTableViewCell)
}

class TodayTaskTableViewCell: UITableViewCell {

    var delegate: TodayTaskCellDelegate?
    var tempPlaceholder = ""
    var taskCompleted = false
    
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var taskToggleButton: CheckMarkToggleButtonBlack!
    
    @IBOutlet weak var taskTextView: UITextView!
    
    @IBAction func didTapTaskToggle(_ sender: CheckMarkToggleButtonBlack) {
        
        taskCompleted = !taskToggleButton.isSelected
        
        taskCompleted.toggle()
        
        taskCompleted ? taskTextView.strike(type: .single) : taskTextView.unstrike()
        
        delegate?.updateTaskCell(cell: self, completed: taskCompleted)
    
    }
    
    @IBAction func didTapAddTaskButton(_ sender: Any) {
        
        self.taskTextView.becomeFirstResponder()
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        taskTextView?.delegate = self
       
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension TodayTaskTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        taskTextView.unstrike()
        
        // Truncate the placeholder if it is too long
        
        if textView.text.isEmpty {
            
            if tempPlaceholder.count > 25 {
                
               let placeHolder = String(tempPlaceholder.prefix(27)) + "..."
               
                textView.placeholder = placeHolder
                
            } else {
                
                textView.placeholder = tempPlaceholder
                
            }
            
        }
        
        let size = CGSize(width: textView.frame.size.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.frame.size.height = estimatedSize.height
        delegate?.self.updateCellHeight()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if (text == "\n"){
            textView.resignFirstResponder()
        }
        return true
    }
    

    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        tempPlaceholder = textView.text
        
        delegate?.updateTaskCell(cell: self, name: textView.text!)
        
        addTaskButton.isHidden = true
        taskToggleButton.isHidden = false
        
        // delegate?.moveToBottomOfTableView(cell: self)
        
        delegate?.createNewTask(cell: self)
        
        //delegate?.moveToBottomOfTableView(cell: self)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        // delegate?.moveToBottomOfTableView(cell: self)
        
        textView.unstrike()
        tempPlaceholder = textView.text
        
    }
    
}
