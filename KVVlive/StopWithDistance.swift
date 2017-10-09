//
//  StopWithDistance.swift
//  KVVlive
//
//  Created by Marijan Petricevic on 07.10.17.
//  Copyright © 2017 Marijan Petricevic. All rights reserved.
//

import Foundation

/**
 Subclass of Stop, has an additional variable distance
 - Author:
 Marijan Petricevic
 - Attributes:
 - distance in meters
 */

public class StopWithDistance: Stop {
    
    override public var description: String {
        return super.description + " distance: \(distance)"
    }
    
    public let distance: Int
    
    override init(from json: [String : Any]) throws {
        guard let distance = json["distance"] as? Int else {
            throw SerializationError.missing("distance")
        }
        
        self.distance = distance
        
        try super.init(from: json)
    }
    
    static func serialize(data: Data) -> [StopWithDistance]? {
        var res: [StopWithDistance] = []
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let jsonStops = json["stops"] as? [[String: Any]] {
                for jsonStop in jsonStops {
                    do {
                        let stop = try StopWithDistance(from: jsonStop)
                        res.append(stop)
                    } catch SerializationError.missing(let m) {
                        print("JSON-Object is incomplete: missing " + m)
                    }
                }
            }
        } catch {
            print("Error deserializing JSON: \(error)")
            return nil
        }
        return res
    }
    
}
