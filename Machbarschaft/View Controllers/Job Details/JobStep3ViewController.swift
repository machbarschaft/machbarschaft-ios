//
//  JobStep3ViewController.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 23.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit

class JobStep3ViewController: UIViewController {
    
    @IBOutlet weak var jobSummaryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var job: Job!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        jobSummaryLabel.text = "\(job.type.title) für \(job.clientName)"
    }
    
    @IBAction func getRoute(_ sender: Any) {
        
    }
    
    @IBAction func callNow(_ sender: Any) {
        
    }
    
    @IBAction func completeJob(_ sender: Any) {
        performSegue(withIdentifier: "JobStep3_to_JobCompleted", sender: nil)
    }
}
