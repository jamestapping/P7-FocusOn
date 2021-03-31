//
//  CheckMarkToggleWhite.swift
//  FocusOn
//
//  Created by James Tapping on 23/03/2021.
//

import Foundation
import UIKit

class CheckMarkToggleButtonWhite: UIButton {
    
    let impactGenerator = UIImpactFeedbackGenerator()
    let tick = UIImage(named: "tick-white")
    let untick = UIImage(named: "untick-white")
    let unTickScale: CGFloat = 0.7
    let tickScale: CGFloat = 1.9
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    deinit {
    
    }
    
    func initButton() {
        
        //adjustsImageWhenHighlighted = false
        addTarget(self, action: #selector(activateButton), for: .touchUpInside)
        
        setImage(untick, for: .normal)
        
        setImage(tick, for: .selected)
    }
    
    @objc func activateButton(){
        
        impactGenerator.impactOccurred()
        
        self.isSelected.toggle()
        animate()
        
   }
    
      func animate() {
        UIView.animate(withDuration: 0.1, animations: {
          let newImage = self.isSelected ? self.tick : self.untick
          let newScale = self.isSelected ? self.tickScale : self.unTickScale
          self.transform = self.transform.scaledBy(x: newScale, y: newScale)
          self.setImage(newImage, for: .normal)
        }, completion: { _ in
          UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform.identity
          })
        })
      }
}


