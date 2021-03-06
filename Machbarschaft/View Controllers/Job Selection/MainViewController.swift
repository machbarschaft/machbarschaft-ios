//
//  MainViewController.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit
import OverlayContainer
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet weak var overlayContainerView: UIView!
    let overlayController = OverlayContainerViewController(style: .flexibleHeight)
    let mapViewController = viewController(withID: "MapViewController") as? MapViewController
    let jobTableViewController = viewController(withID: "JobMenuViewController") as? JobsTableViewController
    
    let jobService = JobService()
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        navigationController?.popAllPreviousViewControllers()
        overlayController.delegate = self
        overlayController.viewControllers = [jobTableViewController!]
        addChild(overlayController, in: view)
        if mapViewController != nil {
            mapViewController?.delegate = self
            addChild(mapViewController!, in: overlayContainerView)
        }
        
        jobTableViewController!.shouldSegueToJobSummary = { job in
            self.performSegue(withIdentifier: "Main_to_JobSummary", sender: job)
        }
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if
            let nav = segue.destination as? UINavigationController,
            let dest = nav.viewControllers.first as? JobSummaryViewController,
            let job = sender as? Job {
            dest.job = job
        }
    }
}

extension MainViewController: OverlayContainerViewControllerDelegate {
    enum OverlayNotch: Int, CaseIterable {
        case minimum, maximum
    }
    
    func overlayContainerViewController(_ containerViewController: OverlayContainerViewController, heightForNotchAt index: Int, availableSpace: CGFloat) -> CGFloat {
        switch OverlayNotch.allCases[index] {
        case .maximum:
            return availableSpace * 0.75
        case .minimum:
            return availableSpace * 0.3
        }
    }
    
    func numberOfNotches(in containerViewController: OverlayContainerViewController) -> Int {
        OverlayNotch.allCases.count
    }
}


extension MainViewController: MapViewControllerDelegate {
    func didSelectJob(_ job: Job) {
        jobTableViewController?.highlightJob(job)
    }
}


extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            jobService.loadJobs(location: location.coordinate, completion: { (jobs) in
                self.mapViewController?.update(userLocation: location.coordinate, jobs: jobs)
                self.jobTableViewController?.update(jobs: jobs)
            })
        }
    }
}
