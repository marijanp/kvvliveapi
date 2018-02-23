//
//  Departure.swift
//  KVVlive
//
//  Created by Marijan (mdvjd) on 07.10.17.
//

import Foundation

/**
 Represents a departure of a public transportation.
 - parameters:
     - route of the public transportation.
     - destination
     - direction is one or two.
     - time of the departure.
     - realtime
     - lowfloor disability-friendly or not.
     - traction tracting force.
     - stopPosition
 */

public struct Departure : CustomStringConvertible {
    
    public var description: String {
        get {
            return "route: \(route) destination: \(destination) direction: \(direction) time: \(time) lowfloor: \(lowfloor) realtime: \(realtime) traction: \(traction) stopPosition: \(stopPosition)"
        }
    }
    
    public let route: String
    public let destination: String
    public let direction: Int
    public let time: String
    public let lowfloor: Bool
    public let realtime: Bool
    public let traction: Int
    public let stopPosition: Int
    
    init(from json: [String: Any]) throws {
        guard let route = json["route"] as? String else {
            throw SerializationError.missing("name")
        }
        guard let destination = json["destination"] as? String else {
            throw SerializationError.missing("destination")
        }
        guard let direction = json["direction"] as? String else {
            throw SerializationError.missing("direction is missing")
        }
        guard let time = json["time"] as? String else {
            throw SerializationError.missing("time")
        }
        guard let lowfloor = json["lowfloor"] as? Bool else {
            throw SerializationError.missing("lowfloor")
        }
        guard let realtime = json["realtime"] as? Bool else {
            throw SerializationError.missing("realtime")
        }
        guard let traction = json["traction"] as? Int else {
            throw SerializationError.missing("traction")
        }
        guard let stopPosition = json["stopPosition"] as? String else {
            throw SerializationError.missing("stopPosition")
        }
        self.route = route
        self.destination = destination
        self.direction = Int(direction)!
        self.time = time
        self.lowfloor = lowfloor
        self.realtime = realtime
        self.traction = traction
        self.stopPosition = Int(stopPosition)!
    }
    
    /**
     Serializes JSON-Data to a optional array of departures.
     - parameters:
         - data: JSON-Formated data.
     - returns: A optional array of departures. The array will be nil, if the serialization fails.
     */
    static func deserialize(_ data: Data) -> [Departure]? {
        var res: [Departure] = []
        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                let jsonDepartures = json["departures"] as? [[String: Any]] {
                for jsonDeparture in jsonDepartures {
                    do {
                        let departure = try Departure(from: jsonDeparture)
                        res.append(departure)
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
