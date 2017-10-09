//
//  Stop.swift
//  KVVlive
//
//  Created by Marijan Petricevic on 07.10.17.
//  Copyright © 2017 Marijan Petricevic. All rights reserved.
//

import Foundation

/**
 Represents a Stop.
 - Author: Marijan Petricevic
 - parameters:
     - route
     - name
     - coordinates as tuple (lat: Double, lon: Double)
 */
public class Stop : CustomStringConvertible {
    
    public var description: String {
        get {
            return "id: \(id) name: \(name) lat: \(coordinates.lat) lon: \(coordinates.lon)"
        }
    }
    
    public let id: String
    public let name: String
    public let coordinates: (lat: Double, lon: Double)
    
    init(from json: [String: Any]) throws {
        guard let id = json["id"] as? String else {
            throw SerializationError.missing("id")
        }
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        guard let lat = json["lat"] as? Double else {
            throw SerializationError.missing("lat")
        }
        guard let lon = json["lon"] as? Double else {
            throw SerializationError.missing("lon")
        }
        
        self.id = id
        self.name = name
        self.coordinates.lat = lat
        self.coordinates.lon = lon
    }
    /**
     Serializes JSON-Data to a optional array of stops
     */
    static func serialize(data: Data) -> [Stop]? {
        var res: [Stop] = []
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let jsonStops = json["stops"] as? [[String: Any]] {
                for jsonStop in jsonStops {
                    do {
                        let stop = try Stop(from: jsonStop)
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
