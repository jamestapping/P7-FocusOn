//
//  UITableViewController + taskSuccessMessage.swift
//  FocusOn
//
//  Created by James Tapping on 26/04/2021.
//

import Foundation
import UIKit

extension UITableViewController {
    
    enum MessageType {
        
        case failure, success
    }
    
    func showTaskAnimatedMessage(_ messageType: MessageType) {
        
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 49.0
        
        let midnightBlue = UIColor(named: "MidnightBlue")
        let messageWidth = tableView.frame.size.width/16.0*14.0 + 12
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height + 250 , width: messageWidth, height: 44))
        toastLabel.center.x = self.view.center.x
        toastLabel.backgroundColor = midnightBlue!.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name: "Helvetica Neue Bold", size: 20)
        toastLabel.textAlignment = .center
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 17
        toastLabel.clipsToBounds = true
        
        switch messageType {
        
        case .failure:
            
            toastLabel.text = generateFailureString()
        
        case .success:
            
            toastLabel.text = generateSuccessString()
            
        }
        
            if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                
                    window.addSubview(toastLabel)
    
                }
            
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5 , initialSpringVelocity: 12, options: .curveLinear, animations: {
                
                toastLabel.transform = CGAffineTransform(translationX: 0, y: -tabBarHeight + -310)
                toastLabel.alpha = 1
            })
            
            UIView.animate(withDuration: 0.3, delay: 1.2, options:
                UIView.AnimationOptions.transitionFlipFromTop, animations: {
                toastLabel.alpha = 0
                toastLabel.transform = CGAffineTransform(translationX: 0, y: 165)
            }, completion: { finished in
                toastLabel.removeFromSuperview()
            })
        }
    
    
  }
    
func generateSuccessString() -> String {
    
    let successMessages = ["Hey hey, keep it up!", "Nice job, you do indeed rock!",
                           "Well Done!", "Yes!","You are on a roll!", "Excellent progress!",
                           "Great Job!", "Nice going!", "Way to go!"]
    
    return successMessages.randomElement()!
}

func generateFailureString() -> String {
    
    let failureMessages = ["Oh No, nevermind!", "You were so close :(",
                           "Better luck next time", "Oh dear!","Argghh, oh well :(",
                           "Not the end of the world :)",
                           "Keep trying ...", "Could do better :)", "You can still do this!"]
    
    return failureMessages.randomElement()!
}
