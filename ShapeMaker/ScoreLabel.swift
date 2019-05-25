//
//  ScoreLabel.swift
//  ShapeMaker
//
//  Created by hackeru on 25/05/2019.
//  Copyright © 2019 erez8. All rights reserved.
//

import UIKit

class ScoreLabel: UILabel {

    var score = 0 {
        didSet{
            self.text = "Score: \(score)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScoreLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupScoreLabel()
    }
    
     func setupScoreLabel() {
        self.score = 0
        self.textColor = .cyan
        self.font = UIFont.boldSystemFont(ofSize: 24)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
}
