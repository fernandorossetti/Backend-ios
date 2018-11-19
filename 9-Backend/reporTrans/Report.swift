//
//  Report.swift
//  reporTrans
//
//  Created by fernando rossetti on 2/6/17.
//  Copyright © 2017 fernando rossetti. All rights reserved.
//

import Foundation

enum TypeVehicle: Int {
    case Taxi
    case MicroBus
    case Bus
}

enum Score: Int {
    case Good
    case Bad
}

struct Report {
    let number: String
    let date: String
    let score: String
    let comment: String
    let type: String
    
    init(number: String, date: String, score: String, comment: String, type: String) {
        self.number = number
        self.date = date
        self.score = score
        self.comment = comment
        self.type = type
    }
}