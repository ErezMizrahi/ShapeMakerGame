//
//  ConnectionView.swift
//  ShapeMaker
//
//  Created by hackeru on 23/05/2019.
//  Copyright © 2019 erez8. All rights reserved.
//

import UIKit

class ConnectionView: UIView {

    var dragChanged : (() -> Void)?
    var dragFininshed : (() -> Void)?
    var touchStartedPos = CGPoint.zero
    var after : ConnectionView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = self.bounds.width * 0.5
        self.layer.borderWidth = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        self.touchStartedPos = touch.location(in: self)
        
        self.touchStartedPos.x = frame.width / 2
        self.touchStartedPos.y = frame.height / 2
        
        //make the view bigger when dragging by 15%
        self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        
        //tell the super view to bring our view above all others
        superview?.bringSubviewToFront(self)
        
    }

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        //where the user dragged the view on the superview
        let point = touch.location(in: superview)
        
        
        self.center = CGPoint(x: point.x - self.touchStartedPos.x, y: point.y - self.touchStartedPos.y)
        
        dragChanged?()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // get the view to original size
        self.transform = .identity
        
        dragFininshed?()
        
    }
    
    //when the app is inactive like when a phone call happend or any thing that can cancel the touch
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
}
