//
//  Card.swift
//  Overfloweth
//
//  Created by Shaun Anderson on 28/5/18.
//  Copyright © 2018 Shaun Anderson. All rights reserved.
//

import Foundation

struct ResponseData: Decodable {
    var Cards: [Card]
}

struct Card: Decodable {
    var rank: String
    var actionName: String
    var actionDescription: String
    var suit: SuitType?
}

enum SuitType: String, Codable {
    case Diamond
    case Spade
    case Club
    case Heart
    
    static let allValues = [Diamond, Spade, Club, Heart]
}
