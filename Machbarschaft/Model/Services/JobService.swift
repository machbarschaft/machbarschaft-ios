//
//  NetworkFunctions.swift
//  Machbarschaft
//
//  Created by Florian on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class JobService {
    
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func matchJobData(data: [String:Any]) -> Job? {
        var location : CLLocationCoordinate2D? = nil
        var jobType : JobType = .misc
        var urgency : JobUrgency = .undefined
        var status : JobStatus = .open
        var description = ""
        var city = ""
        var zip = ""
        var houseNumber = ""
        var street = ""
        
        if let typeX = data["type_of_help"] as? String {
            switch typeX.uppercased() {
            case "APOTHEKE": jobType = .medicine
            case "EINKAUFEN": jobType = .groceries
            default: jobType = .misc
            }
            description = jobType.title
        }
        if let urgencyX = data["urgency"] as? String {
            switch urgencyX.uppercased() {
            case "TODAY": urgency = .today
            case "TOMORROW": urgency = .tomorrow
            case "ASAP": urgency = .urgent
            default: urgency = .undefined
            }
        }
        if let statusX = data["status"] as? String {
            switch statusX.uppercased() {
            case "OPEN": status = .open
            case "CLOSED": status = .inProgress
            case "INPROGRESS": status = .inProgress
            default: status = .open
            }
        }
        if let lat = data["lat"] as? Double, let lng = data["lng"] as? Double {
            location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        }
        if let addressData = data["address"] as? [String: Any] {
            city = addressData["city"] as? String ?? ""
            street = addressData["street"] as? String ?? ""
            zip = addressData["zip"] as? String ?? ""
            houseNumber = addressData["houseNumber"] as? String ?? ""
        }
        let result = Job(
            jobID: 0,
            type: jobType,
            urgency: urgency,
            status: status,
            clientName: (data["name"] as? String) ?? "",
            clientPhone: (data["phone_number"] as? String) ?? "",
            city: city,
            zip: zip,
            location: location,
            distanceInMeters: 0,
            street: street,
            houseNumber: houseNumber,
            description: description
        )
        return result
    }
    
    func loadJobs(withStatus : String? = nil, location: CLLocationCoordinate2D, completion: @escaping (_ jobs: [Job]) -> Void) {
        //TODO: Use the given location to load only relevant jobs!
        
        let docRef = db.collection("Order")
        if withStatus != nil {
            docRef.whereField("status", isEqualTo: withStatus as Any)
        }
        docRef.getDocuments() { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion([])
            } else {
                var jobs : [Job] = []
                var jobIdCounter = 1
                for document in document!.documents {
                    let data = document.data()
                    if var job = self.matchJobData(data: data) {
                        job.jobID = jobIdCounter
                        if let jobLocation = job.location {
                            job.distanceInMeters = getDistance(from: location, to: jobLocation)
                        }
                        jobs.append(job)
                        jobIdCounter += 1
                    }
                }
                completion(jobs)
            }
        }
    }
}
