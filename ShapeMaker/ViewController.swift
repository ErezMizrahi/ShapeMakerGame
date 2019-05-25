//
//  ViewController.swift
//  ShapeMaker
//
//  Created by hackeru on 23/05/2019.
//  Copyright © 2019 erez8. All rights reserved.
//

import UIKit

class ViewController: UIViewController  {
  
    

    var currentLevel = 0
    var connections = [ConnectionView]()
    
    var renderdLine = UIImageView()
    
    let scoreLabel = ScoreLabel()

 
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
        setupScoreLabel()
       
        
        setupLines()

        levelUp()
    }

     func setupScoreLabel() {
   
        self.view.addSubview(scoreLabel)
        
        scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scoreLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant : -20).isActive = true
    }
    
    
     func setupLines() {
        self.renderdLine.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(renderdLine)
        
        renderdLine.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        renderdLine.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        renderdLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        renderdLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func levelUp() {
        if scoreLabel.score < 0{
            self.currentLevel = 0
        }
        self.currentLevel += 1
        self.scoreLabel.score  += 1
        
        self.connections.forEach({ $0.removeFromSuperview()})
        self.connections.removeAll()
        
        for _ in 1...(currentLevel + 4) {
        let connection = ConnectionView(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
    
            connections.append(connection)
            self.view.addSubview(connection)
            
            
            connection.dragChanged = { [weak self] in
                self?.redrawLines()
            }
            
            connection.dragFininshed = { [weak self] in
                self?.checkMove()
                
            }
        }
        
        for i in 0..<connections.count {
            if i == connections.count - 1 //last index
            {
                connections[i].after = connections[0]
            } else {
                connections[i].after = connections[i + 1]
            }
        }
        
        repeat{
        connections.forEach(place(_:))
        } while levelClear()
        
            self.redrawLines()
    }
    

    func place (_ connection : ConnectionView) {
        let randomX = CGFloat.random(in: 20...self.view.bounds.maxX - 20)
        let randomY = CGFloat.random(in: 50...self.view.bounds.maxY - 50)

        connection.center = CGPoint(x: randomX, y: randomY)
    }


    func redrawLines() {
        let render = UIGraphicsImageRenderer(bounds: view.bounds)

        self.renderdLine.image = render.image { context in
            for connection in connections {
                var isLineClear = true

                for other in connections {
                    if linesCross(start1: connection.center, end1: connection.after.center, start2: other.center, end2: other.after.center) != nil {
                        isLineClear = false
                        break
                    }
                }
                if isLineClear  {
                    UIColor.green.set()
                } else {
                    UIColor.red.set()
                }
                context.cgContext.strokeLineSegments(between: [connection.after.center, connection.center])
            }

        }

    }

    func linesCross(start1: CGPoint, end1: CGPoint, start2: CGPoint, end2: CGPoint) -> (x: CGFloat, y: CGFloat)? {
        // calculate the differences between the start and end X/Y positions for each of our points
        let delta1x = end1.x - start1.x
        let delta1y = end1.y - start1.y
        let delta2x = end2.x - start2.x
        let delta2y = end2.y - start2.y

        // create a 2D matrix from our vectors and calculate the determinant
        let determinant = delta1x * delta2y - delta2x * delta1y

        if abs(determinant) < 0.0001 {
            // if the determinant is effectively zero then the lines are parallel/colinear
            return nil
        }

        // if the coefficients both lie between 0 and 1 then we have an intersection
        let ab = ((start1.y - start2.y) * delta2x - (start1.x - start2.x) * delta2y) / determinant

        if ab > 0 && ab < 1 {
            let cd = ((start1.y - start2.y) * delta1x - (start1.x - start2.x) * delta1y) / determinant

            if cd > 0 && cd < 1 {
                // lines cross – figure out exactly where and return it
                let intersectX = start1.x + ab * delta1x
                let intersectY = start1.y + ab * delta1y
                return (intersectX, intersectY)
            }
        }

        // lines don't cross
        return nil
    }
//
    func levelClear() -> Bool {
        for connection in connections {
            for other in connections {
                if linesCross(start1: connection.center, end1: connection.after.center, start2: other.center, end2: other.after.center) != nil {
                    return false
                }
                
            }
        }
        return true
    }
    
    func checkMove() {
        if levelClear() {
           
            self.scoreLabel.score  += currentLevel * 2
            self.view.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: 0.5, delay: 1, options: [], animations: { [weak self] in
                self?.renderdLine.alpha = 0
                
                for connection in (self?.connections)! {
                    connection.alpha = 0
                }
            }) { [weak self] finised in
                self?.view.isUserInteractionEnabled = true
                self?.renderdLine.alpha = 1
                self?.levelUp()
            }
        } else {
            // they are still playing this level
            self.scoreLabel.score  -= 1
            if scoreLabel.score < 0 {
                let alert = UIAlertController(title: "Level Faild", message: "ohhh it's ok, just press Restart", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
                    
                    self.levelUp()
                }))
                present(alert, animated: true, completion: nil)
            }
            
        }
    }

}


protocol iGamplay {
//    func checkMove()
//    func levelUp()
//    func levelClear()
    func linesCross(start1: CGPoint, end1: CGPoint, start2: CGPoint, end2: CGPoint) -> (x: CGFloat, y: CGFloat)?
    func place (_ connection : ConnectionView)
    func redrawLines()
//
}




