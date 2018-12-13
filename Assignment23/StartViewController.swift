//
//  StartViewController.swift
//  Assignment23
//
//  Created by Xcode User on 2018-11-28.
//  Copyright © 2018 Xcode User. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func PlayDaGame(sender: AnyObject) {
        NSLog("start game")
    }

    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "StartGameSegue" {
            if let gameViewController = segue.destination as? GameViewController {
            }
        }
    }
    
}
