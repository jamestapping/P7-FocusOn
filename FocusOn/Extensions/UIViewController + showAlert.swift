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

        let serenity = UIColor(named: "Serenity")
        let midnightBlue = UIColor(named: "MidnightBlue")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        for(index, indexTitle) in actionTitles.enumerated(){
            let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: actions[index])
            alertController.addAction(action)
        }
        
        clearBackgroundColor(of: alertController.view)
        
        alertController.view.layer.backgroundColor = serenity!.withAlphaComponent(0.95).cgColor
        alertController.view.layer.cornerRadius = 15
        alertController.view.layer.borderWidth = 1
        alertController.view.layer.borderColor = midnightBlue!.cgColor
        alertController.view.tintColor = midnightBlue!
        
        self.present(alertController, animated: true) {
            
            alertController.view.superview?.subviews.first?.isUserInteractionEnabled = true
            alertController.view.superview?.subviews.first?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.actionSheetBackgroundTapped)))
            
        }
    }
    
    @objc func actionSheetBackgroundTapped() {
        
        // Un-comment the below if you want the action sheet to be remove when tapped outside of it.
        
        // self.dismiss(animated: true, completion: nil)
        
    }
    
    func clearBackgroundColor(of view: UIView) {
        if let effectsView = view as? UIVisualEffectView {
            effectsView.removeFromSuperview()
            return
        }

        view.backgroundColor = .clear
        view.subviews.forEach { (subview) in
            clearBackgroundColor(of: subview)
        }
    }
}
