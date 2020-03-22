//
//  JobStep1ViewController.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit

class JobStep1ViewController: UIViewController {
    
    var job: Job!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isModalInPresentation = true
    }
    
    @IBAction func callNow(_ sender: Any) {
        performSegue(withIdentifier: "JobStep1_to_JobStep2", sender: nil)
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let dest = segue.destination as? JobStep1ViewController {
            dest.job = job
        }
    }
}
