//
//  MapViewController.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit
import MapKit

class JobAnnotation: MKPointAnnotation {
    var job: Job
    init(job: Job) {
        self.job = job
    }
}

protocol MapViewControllerDelegate {
    func didSelectJob(_ job: Job)
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var delegate: MapViewControllerDelegate?
    
    var hasSetRegion: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    func update(userLocation: CLLocationCoordinate2D, jobs: [Job]) {
        
        var annotations: [JobAnnotation] = []
        for job in jobs {
            if let annotation = annotationForJob(job) {
                annotations.append(annotation)
            }
        }
        
        if !hasSetRegion {
            let mapEdgePadding = UIEdgeInsets(top: 70, left: 70, bottom: 250, right: 70)
            var zoomRect = extendRectWithPoint(rect: .null, point: MKMapPoint(userLocation))
            for annotation in annotations {
                zoomRect = extendRectWithPoint(rect: zoomRect, point: MKMapPoint(annotation.coordinate))
            }
            mapView.setVisibleMapRect(zoomRect, edgePadding: mapEdgePadding, animated: true)
            
            hasSetRegion = true
        }
            
        mapView.addAnnotations(annotations)
    }
    
    func annotationForJob(_ job: Job) -> JobAnnotation? {
        guard job.location != nil else {
            return nil
        }
        let annotation = JobAnnotation(job: job)
        annotation.title = job.type.title
        annotation.coordinate = job.location!
        return annotation
    }
    
    func extendRectWithPoint(rect: MKMapRect, point: MKMapPoint) -> MKMapRect {
        let pointRect = MKMapRect(x: point.x, y: point.y, width: 0.1, height: 0.1)
        return rect.isNull ? pointRect : rect.union(pointRect)
    }
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is JobAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // TODO: - I removed the force cast.
        // Old code:
        // let annotation: JobAnnotation = view.annotation as! JobAnnotation
        if let annotation: JobAnnotation = view.annotation as? JobAnnotation {
            delegate?.didSelectJob(annotation.job)
        }
    }
}
