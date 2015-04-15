//
//  ViewController.swift
//  UIMultiSpaceBar
//
//  Created by EyreFree on 15/4/14.
//  Copyright (c) 2015 EyreFree. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var testBar: UIMultiSpaceBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //must override to set detail of the bar
    override func viewDidLayoutSubviews() {
        testBar.setDetail("test title",
                backBGColor: UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1),
                frontBGColors: [UIColor(red: 220/255, green: 78/255, blue: 78/255, alpha: 1), UIColor(red: 78/255, green: 152/255, blue: 220/255, alpha: 1), UIColor(red: 66/255, green: 193/255, blue: 17/255, alpha: 1)],
                multi: 5,
                width: testBar.bounds.width,
                height: testBar.bounds.height)
    }
    
    @IBAction func testAction(sender: AnyObject) {
        testBar.changePercentage(0)
    }
    @IBAction func testAction_2(sender: AnyObject) {
        testBar.changePercentage(60)
    }
    @IBAction func testAction_3(sender: AnyObject) {
        testBar.changePercentage(100)
    }
}

