//
//  JobStep3ViewController.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 23.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit
import MapKit

class JobStep3ViewController: UIViewController {
    
    @IBOutlet weak var jobSummaryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var job: Job!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        jobSummaryLabel.text = "\(job.type.title) für \(job.clientName)"
        
        mapView.clipsToBounds = true
        if let location = job.location {
            mapView.centerToLocation(location)
        }
    }
    
    @IBAction func getRoute(_ sender: Any) {
        
    }
    
    @IBAction func callNow(_ sender: Any) {
        
    }
    
    @IBAction func completeJob(_ sender: Any) {
        performSegue(withIdentifier: "JobStep3_to_JobCompleted", sender: nil)
    }
}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocationCoordinate2D,
    regionRadius: CLLocationDistance = 10000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
