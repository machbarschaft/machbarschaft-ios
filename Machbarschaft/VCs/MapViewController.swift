//
//  MapViewController.swift
//  Machbarschaft
//
//  Created by Linus Geffarth on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    func update(userLocation: CLLocationCoordinate2D, jobs: [Job]) {
        
        var annotations: [MKPointAnnotation] = []
        for job in jobs {
            if let annotation = annotationForJob(job) {
                annotations.append(annotation)
            }
        }
        
        let mapEdgePadding = UIEdgeInsets(top: 70, left: 70, bottom: 250, right: 70)
        var zoomRect = extendRectWithPoint(rect: .null, point: MKMapPoint(userLocation))
        for annotation in annotations {
            zoomRect = extendRectWithPoint(rect: zoomRect, point: MKMapPoint(annotation.coordinate))
        }
        mapView.setVisibleMapRect(zoomRect, edgePadding: mapEdgePadding, animated: true)
        
        mapView.addAnnotations(annotations)
    }
    
    func annotationForJob(_ job: Job) -> MKPointAnnotation? {
        guard job.location != nil else {
            return nil
        }
        let annotation = MKPointAnnotation()
        annotation.title = job.type.title
        annotation.coordinate = job.location!
        return annotation
    }
    
    func extendRectWithPoint(rect: MKMapRect, point: MKMapPoint) -> MKMapRect {
        let pointRect = MKMapRect(x: point.x, y: point.y, width: 0.1, height: 0.1)
        if rect.isNull {
            return pointRect
        } else {
            return rect.union(pointRect)
        }
    }
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

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
}
