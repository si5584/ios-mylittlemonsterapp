//
//  MonsterImg.swift
//  mylittlemonster
//
//  Created by Simon Lovelock on 12/01/2016.
//  Copyright © 2016 haloApps. All rights reserved.
//

import Foundation
import UIKit

class MonsterImg : UIImageView {
    
    var characterString : String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func setCharacter(charId:Int) {
        if charId == 1 {
            self.characterString = "monster"
        } else if charId == 2 {
            self.characterString = "hero"
        }
    }
    
    func playIdleAnimation () {
        
        self.image = UIImage(named: "\(characterString)Idle1.png")
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        
        for var x = 1; x <= 4; x++ {
            let img = UIImage(named: "\(characterString)Idle\(x).png")
            imgArray.append(img!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 1.1
        self.animationRepeatCount = 0
        self.startAnimating()
        
    }
    
    func playDeathAnimation () {
        
        self.image = UIImage(named: "\(characterString)Dead5.png")
        self.animationImages = nil
        
        var imgArray = [UIImage] ()
        
        for var x = 1; x <= 5; x++ {
            let img = UIImage(named: "\(characterString)Dead\(x).png")
            imgArray.append(img!)
            
            self.animationImages = imgArray
            self.animationDuration = 0.8
            self.animationRepeatCount = 1
            self.startAnimating()
        }
        
    }
    
}