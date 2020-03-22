//
//  JobSummaryViewController.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit
import MapKit

class JobSummaryViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobDescriptionLabel: UILabel!
    @IBOutlet weak var urgencyLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var job: Job!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = job.clientName
        jobDescriptionLabel.text = job.description
        urgencyLabel.text = job.urgency.title
        addressLabel.text = job.clientAddress
    }
    
    @IBAction func acceptJob(_ sender: UIButton) {
        performSegue(withIdentifier: "JobSummary_to_JobStep1", sender: nil)
    }
    
    @IBAction func dismissVC(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let dest = segue.destination as? JobStep1ViewController {
            dest.job = job
        }
    }
}
