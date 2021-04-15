//
//  UITableViewController + showAlert.swift
//  FocusOn
//
//  Created by James Tapping on 07/04/2021.
//

import Foundation
import UIKit

extension UITableViewController{

    public func showAlert(title: String,
                          message: String,
                          alertStyle:UIAlertController.Style,
                          actionTitles:[String],
                          actionStyles:[UIAlertAction.Style],
                          actions: [((UIAlertAction) -> Void)]){

        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        for(index, indexTitle) in actionTitles.enumerated(){
            let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: actions[index])
            alertController.addAction(action)
        }
        
        self.present(alertController, animated: true) {
            
            alertController.view.superview?.subviews.first?.isUserInteractionEnabled = true
            alertController.view.superview?.subviews.first?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.actionSheetBackgroundTapped)))
            
        }
    }
    
    @objc func actionSheetBackgroundTapped() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
}
