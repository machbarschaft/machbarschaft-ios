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
        
        jobSummaryLabel.text = "\(job.type.title) für \(job.clientName)"
    }
    
    @IBAction func leavingNow(_ sender: Any) {
        performSegue(withIdentifier: "JobStep2_to_JobStep3", sender: nil)
    }
    
    @IBAction func leavingLater(_ sender: Any) {
        
    }
    
    @IBAction func couldntReachAnyone(_ sender: Any) {
        
    }
    
    @IBAction func callNow(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let dest = segue.destination as? JobStep3ViewController {
            dest.job = job
        }
    }
}
