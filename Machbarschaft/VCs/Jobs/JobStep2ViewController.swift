//
//  JobStep2ViewController.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit

class JobStep2ViewController: UIViewController {
    
    @IBOutlet weak var jobSummaryLabel: UILabel!
    
    var job: Job!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isModalInPresentation = true
    }
    
    @IBAction func leavingNow(_ sender: Any) {
        
    }
    
    @IBAction func leavingLater(_ sender: Any) {
        
    }
    
    @IBAction func couldntReachAnyone(_ sender: Any) {
        
    }
}
