//
//  Job.swift
//  Machbarschaft
//
//  Created by Robert Ecker on 22.03.20.
//  Copyright © 2020 Linus Geffarth. All rights reserved.
//

import CoreLocation

enum JobType {
    case medicine
    case groceries
    case misc
}

enum JobUrgency {
    case urgent
    case today
    case tomorrow
}

enum JobStatus {
    case open
    case inProgress
    case done
}

struct Job {
    var type: JobType
    var urgency: JobUrgency
    var status: JobStatus
    var clientName: String
    var clientPhone: String
    var city: String
    var zip: String
    var location: CLLocationCoordinate2D
    var address: String
}
