//
//  ConstraintsHelper.swift
//  8.2.MeMe.2.0.rev
//
//  Created by mairo on 07/08/2022.
//

import Foundation
import UIKit

class ConstraintsHelper {
    
    static func applyLandscapeConstraints(view: UIView, topTextField: UITextField, bottomTextField: UITextField) -> [NSLayoutConstraint] {
        var landscapeConstraints = [NSLayoutConstraint]()
    
        // don’t automatically create constraints for this view based on whatever information you have about them and trust to use the ones that I am going to provide
        topTextField.translatesAutoresizingMaskIntoConstraints = false
        bottomTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // topTextField defining, adding and appending constraints for top, left, right and height
        let topTextFieldPinToTop = NSLayoutConstraint(item: topTextField, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 30)
        let topTextFieldPinToLeft = NSLayoutConstraint(item: topTextField, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0)
        let topTextFieldPinToRight = NSLayoutConstraint(item: topTextField, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0)
        let toptextFieldHeight = NSLayoutConstraint(item: topTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 50)
        
        
        view.addConstraint(topTextFieldPinToTop)
        landscapeConstraints.append(topTextFieldPinToTop)
        view.addConstraint(topTextFieldPinToLeft)
        landscapeConstraints.append(topTextFieldPinToLeft)
        view.addConstraint(topTextFieldPinToRight)
        landscapeConstraints.append(topTextFieldPinToRight)
        view.addConstraint(toptextFieldHeight)
        landscapeConstraints.append(toptextFieldHeight)
        
        // bottomTextField defining, adding and appending constraints for bottom, left, right and height
        let bottomTextFieldPinToBottom = NSLayoutConstraint(item: bottomTextField, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -30) // -35
        let bottomTextFieldPinToLeft = NSLayoutConstraint(item: bottomTextField, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0)
        let bottomTextFieldPinToRight = NSLayoutConstraint(item: bottomTextField, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0)
        let bottomTextFieldHeight = NSLayoutConstraint(item: bottomTextField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 50)
        
        view.addConstraint(bottomTextFieldPinToBottom)
        landscapeConstraints.append(bottomTextFieldPinToBottom)
        view.addConstraint(bottomTextFieldPinToLeft)
        landscapeConstraints.append(bottomTextFieldPinToLeft)
        view.addConstraint(bottomTextFieldPinToRight)
        landscapeConstraints.append(bottomTextFieldPinToRight)
        view.addConstraint(bottomTextFieldHeight)
        landscapeConstraints.append(bottomTextFieldHeight)
        
        return landscapeConstraints
        
    }
}
