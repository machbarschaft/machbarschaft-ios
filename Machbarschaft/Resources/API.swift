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

class APIClass {
    
    var db: Firestore!

    init() {
        db = Firestore.firestore()
    }
    
    func matchJobData(data: [String:Any]) -> Job? {
        var location : CLLocationCoordinate2D? = nil
        var jobType : JobType = .misc
        var urgency : JobUrgency = .undefined
        var status : JobStatus = .open
        
        if let typeX = data["type_of_help"] as? String {
            switch typeX.uppercased() {
            case "APOTHEKE": jobType = .medicine
            case "EINKAUFEN": jobType = .groceries
            default: jobType = .misc
            }
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
        let result = Job(
            jobID: 0,
            type: jobType,
            urgency: urgency,
            status: status,
            clientName: (data["name"] as? String) ?? "",
            clientPhone: (data["phone_number"] as? String) ?? "",
            city: (data["city"] as? String) ?? "",
            zip: (data["zip"] as? String) ?? "",
            location: location,
            street: (data["street"] as? String) ?? "",
            houseNumber: (data["house_number"] as? String) ?? "",
            description: ""
        )
        return result
    }
    
    // Example Telephone Number: 90821389123
    func getAccount(number: String) -> Any? {
        var result : Any? = nil
        let docRef = db.collection("Account").whereField("phone_number", isEqualTo: number)
        docRef.getDocuments { (document, error) in
        if let error = error {
                    print("Error getting documents: \(error)")
                    result = nil
                } else {
                    for document in document!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                    result = document!.documents
                }
            }
            return result
    }
    
    // Example Order "TmRu3aWu0v8Zc0xQ5AR9"
    func getOrder(orderId: String) -> Job? {
        var result : Job? = nil
        let docRef = db.collection("Order").document(orderId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data() { result = self.matchJobData(data: data) }
                else { result = nil }
            } else {
                print("Document does not exist")
                result = nil
            }
        }
        return result
    }
    
    // API.getOrdersInArea(location: CLLocationCoordinate2D(latitude: 50, longitude: 8.263), range: 10)
    func getOrdersInArea(location: CLLocationCoordinate2D, range: Double) -> [Job]? {
        var result : [Job]? = nil
        let locationBounds = getEdgeCoordinates(midCoordinate: location, distance: range)
        let docRef = db.collection("Order")
        docRef.whereField("lat", isLessThan: locationBounds.upperBound.latitude)
        docRef.whereField("lat", isGreaterThan: locationBounds.lowerBound.latitude)
        docRef.whereField("lng", isLessThan: locationBounds.rightBound.longitude)
        docRef.whereField("lng", isGreaterThan: locationBounds.leftBound.longitude)
        
        docRef.getDocuments { (document, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                    result = nil
                } else {
                    for document in document!.documents {
                        let data = document.data()
                        if let job = self.matchJobData(data: data) {
                            if result == nil {
                                result = []
                            }
                            result?.append(job)
                        }
                    }
                }
            // dump(result)
            // Call Result Handling should be placed here
            }
        return result
    }
   
    // Flag withStatus can be omitted, then all Statuses are called.
    // Status e.g. "open"
    func getAllOrders(withStatus : String? = nil) -> [Job]? {
        var result : [Job]? = nil
        let docRef = db.collection("Order")
        if withStatus != nil {
            docRef.whereField("status", isEqualTo: withStatus as Any)
        }
        docRef.getDocuments() { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                result = nil
            } else {
                for document in document!.documents {
                        let data = document.data()
                        if let job = self.matchJobData(data: data) {
                            if result == nil {
                                result = []
                            }
                            result?.append(job)
                        }
                    }
                }
            }
        return result
    }
    
    
}
