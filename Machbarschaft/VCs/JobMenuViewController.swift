//
//  JobMenuViewController.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit
import CoreLocation


enum SortType {
    case urgency
    case distance
}


class JobMenuViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var urgencyButton: UIButton!
    @IBOutlet weak var urgencyButtonIcon: UIImageView!
    
    @IBOutlet weak var closenessButton: UIButton!
    @IBOutlet weak var closenessButtonIcon: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var sorting = SortType.urgency
    
    var jobs: [Job] = []
    
    var locationManager: CLLocationManager!
    
    var shouldSegueToJobSummary: (_ job: Job) -> Void = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let userLocation = location.coordinate
            
            let api = API
            api?.loadJobs(location: userLocation, completion: { (jobs) in
                self.jobs = jobs
                self.sortJobs()
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func setSorting(_ button: UIButton) {
        let isSortingByUrgency = button == urgencyButton
        
        sorting = isSortingByUrgency ? .urgency : .distance
        
        urgencyButton.setTitleColor(color(isHighlighted: isSortingByUrgency), for: .normal)
        urgencyButtonIcon.tintColor = color(isHighlighted: isSortingByUrgency)
        closenessButton.setTitleColor(color(isHighlighted: !isSortingByUrgency), for: .normal)
        closenessButtonIcon.tintColor = color(isHighlighted: !isSortingByUrgency)
        
        sortJobs()
        tableView.reloadData()
    }
    
    func color(isHighlighted: Bool) -> UIColor {
        let highlightedColor = UIColor(named: "Link")!
        let defaultColor = UIColor(named: "Text")!
        return isHighlighted ? highlightedColor : defaultColor
    }
    
    func sortJobs() {
        if sorting == .urgency {
            jobs = jobs.sorted(by: { $0.urgency.rawValue < $1.urgency.rawValue })
        }
        else {
            jobs = jobs.sorted(by: { $0.distanceInMeters < $1.distanceInMeters })
        }
    }
}

extension JobMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? JobMenuCell,
            let job = jobs[safe: indexPath.row] else { return UITableViewCell() }
        cell.populate(for: job)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
        guard let job = (cell as? JobMenuCell)?.job else { return }
        shouldSegueToJobSummary(job)
    }
}

class JobMenuCell: UITableViewCell {
    
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var flagIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var job: Job!
    
    func populate(for job: Job) {
        self.job = job
        
        indexLabel.text = "\(job.jobID)"
        flagIcon.tintColor = job.urgency.color
        titleLabel.text = job.type.title
        descriptionLabel.text = job.description
        
        let distance = job.distanceInMeters
        switch distance {
        case 0...1000:
            distanceLabel.text =  "\(distance) m"
        case 0...10000:
            let kmDistance = Double(round(Double(distance) / 100)) / 10
            distanceLabel.text = "\(kmDistance) km"
        default:
            let kmDistance = Int(Double(distance) / 1000)
            distanceLabel.text = "\(kmDistance) km"
        }
    }
    
}
