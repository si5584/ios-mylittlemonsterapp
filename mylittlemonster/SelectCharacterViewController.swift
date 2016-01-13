//
//  SelectCharacterViewController.swift
//  mylittlemonster
//
//  Created by Simon Lovelock on 13/01/2016.
//  Copyright © 2016 haloApps. All rights reserved.
//

import UIKit

class SelectCharacterViewController: UIViewController {

    var charId : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func characterSelected(sender: UIButton!) {
        self.charId = sender.tag
        self.performSegueWithIdentifier("selectCharacterToGameSeque", sender: nil)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let gameVC = segue.destinationViewController as! ViewController
        gameVC.characterId = self.charId
    }
}
