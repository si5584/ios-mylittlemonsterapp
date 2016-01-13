//
//  ViewController.swift
//  mylittlemonster
//
//  Created by Simon Lovelock on 11/01/2016.
//  Copyright © 2016 haloApps. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImg : MonsterImg!
    @IBOutlet weak var heartImg : DragImg!
    @IBOutlet weak var foodImg : DragImg!
    @IBOutlet weak var resetLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var penaltyOneImg: UIImageView!
    @IBOutlet weak var penaltyTwoImg: UIImageView!
    @IBOutlet weak var penaltyThreeImg: UIImageView!
    
    var characterId : Int!
    
    let DIM_ALPHA : CGFloat = 0.2
    let OPAQUE : CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer : NSTimer!
    var monsterHappy = false
    var currentItem : UInt32 = 0
    
    var musicPlayer : AVAudioPlayer!
    var sfxBite : AVAudioPlayer!
    var sfxHeart : AVAudioPlayer!
    var sfxDeath : AVAudioPlayer!
    var sfxSkull : AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.monsterImg.setCharacter(characterId!)
        self.monsterImg.playIdleAnimation()
        self.monsterHappy = true
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        
        clearSkulls()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        do {
            try self.musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try self.sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try self.sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try self.sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            try self.sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            self.musicPlayer.prepareToPlay()
            self.musicPlayer.play()
            
            self.sfxBite.prepareToPlay()
            self.sfxDeath.prepareToPlay()
            self.sfxHeart.prepareToPlay()
            self.sfxSkull.prepareToPlay()
            
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        hideOptions()
        startTimer()
    }

    func itemDroppedOnCharacter(notif: AnyObject) {
        self.monsterHappy = true
        startTimer()
        
        if currentItem == 0 {
            self.sfxHeart.play()
        } else {
            self.sfxBite.play()
        }
    }
    
    func startTimer() {
        
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
        
    }
    
    func changeGameState() {
        
        if !monsterHappy {
            penalties++
            
            self.sfxSkull.play()
            
            if penalties == 1 {
                penaltyOneImg.alpha = OPAQUE
                penaltyTwoImg.alpha = DIM_ALPHA
                penaltyThreeImg.alpha = DIM_ALPHA
            } else if penalties == 2 {
                penaltyOneImg.alpha = OPAQUE
                penaltyTwoImg.alpha = OPAQUE
                penaltyThreeImg.alpha = DIM_ALPHA
            } else if penalties >= 3 {
                penaltyOneImg.alpha = OPAQUE
                penaltyTwoImg.alpha = OPAQUE
                penaltyThreeImg.alpha = OPAQUE
            } else {
                penaltyOneImg.alpha = DIM_ALPHA
                penaltyTwoImg.alpha = DIM_ALPHA
                penaltyThreeImg.alpha = DIM_ALPHA
            }
            
        }

        let rand = arc4random_uniform(2) // 0 or 1
        
        if penalties >= MAX_PENALTIES {
            gameOver()
        } else {
            if rand == 0 {
                foodImg.alpha = DIM_ALPHA
                foodImg.userInteractionEnabled = false
                
                heartImg.alpha = OPAQUE
                heartImg.userInteractionEnabled = true
            } else {
                foodImg.alpha = OPAQUE
                foodImg.userInteractionEnabled = true
                
                heartImg.alpha = DIM_ALPHA
                heartImg.userInteractionEnabled = false
            }
        }
        
        self.currentItem = rand
        self.monsterHappy = false
        
    }
    
    func gameOver() {
        hideOptions()
        timer.invalidate()
        monsterImg.playDeathAnimation()
        self.sfxDeath.play()
        
        _ = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "resetReveal", userInfo: nil, repeats: false)
    }
    
    @IBAction func onResetPressed(sender: AnyObject) {
        
        clearSkulls()
        
        self.monsterImg.playIdleAnimation()
        self.penalties = 0
        self.resetButton.hidden = true
        self.resetLabel.hidden = true
        
        startTimer()
        
    }
    
    func clearSkulls() {
        penaltyOneImg.alpha = DIM_ALPHA
        penaltyTwoImg.alpha = DIM_ALPHA
        penaltyThreeImg.alpha = DIM_ALPHA
    }
    
    func resetReveal() {
        self.resetButton.hidden = false
        self.resetLabel.hidden = false
    }
    
    func hideOptions(){
        
        self.foodImg.alpha = DIM_ALPHA
        self.foodImg.userInteractionEnabled = false
        self.heartImg.alpha = DIM_ALPHA
        self.heartImg.userInteractionEnabled = false
        
    }
    
}

