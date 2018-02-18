//
//  Request.swift
//  KVVlive
//
//  Created by Marijan Petricevic on 07.10.17.
//  Copyright © 2017 Marijan Petricevic. All rights reserved.
//

import Foundation

//TODO unused
public enum RequestError : Error {
    case noData(message: String)
}

enum SerializationError : Error{
    case missing(String)
}

//TODO public var newer: Request?
public class Request : NSObject {
    /**
     API key which is neccessary for requests. Gets appended as a [key, value] pair everytime a JSON request is made.
     */
    private let apiKey = "377d840e54b59adbe53608ba1aad70e8"
    
    /**
    Base URL of the KVV.live-homepage.
    */
    private var searchURL = URLComponents(string: "https://live.kvv.de/")!
    
    /**
     Returns JSON Data recieved from a URL. The URL
     
     - returns: JSON Data, which was fetched from the server.
     - parameters:
         - url: The URL which should be requested
     */
    
    private func getJsonData() -> Data? {
        searchURL.queryItems?.append(URLQueryItem(name: "key", value: apiKey))
        let request = URLRequest(url: searchURL.url!)
        let semaphore = DispatchSemaphore(value: 0)
        var recievedData: Data? = Data()
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if statusCode != 200 {
                print("Error, couldn't fetch data from given URL: " + self.searchURL.url!.absoluteString)
                semaphore.signal()
                return
            }
            if let err = error {
                print(err)
                return
            }
            recievedData = data
            semaphore.signal()
        })
        task.resume()
        semaphore.wait()
        return recievedData
    }
    
    /**
     Search for a stop by name.
     
     - parameters:
         - name: String with the name to search for.
         - maxInfos: Maximal number of stops which should be returned. It's 10 by default.
         - handler: Gets called when the stops got fetched. The caller can implement further processing of the stops by passing a closure.
     */
    public func searchStop(by name: String, maxInfos: Int = 10,_ completion: (([Stop]) -> Void)) {
        searchURL.path = "/webapp/stops/byname/" + name
        searchURL.queryItems = [URLQueryItem(name: "maxInfos", value: String(maxInfos))]
        if let data = getJsonData() {
            if let stops = Stop.serialize(data) {
                completion(stops)
            }
        }
    }
    
    /**
     Search for a stop by latitude and longitude.
     - parameters:
         - coordinates: Tuple with latitude and longitude as double-values.
         - maxInfos: Maximal number of stops which should be returned. It's 10 by default.
         - handler: Gets called when the stops got fetched. The caller can implement further processing of the stops by passing closure.
     */
    public func searchStop(by coordinates: (lat: Double, lon: Double), maxInfos: Int = 10, _ completion: (([StopWithDistance]) -> Void)) {
        searchURL.path = "/webapp/stops/bylatlon/" + String(coordinates.lat) + "/" + String(coordinates.lon)
        searchURL.queryItems = [URLQueryItem(name: "maxInfos", value: String(maxInfos))]
        if let data = getJsonData() {
            if let stops: [StopWithDistance] = StopWithDistance.serialize(data) {
                completion(stops)
            }
        }
    }
    /**
     Get Departures from a Stop by the wanted route.
     - parameters:
         - route: String of wanted route e.g. "S11"
         - stopId: String with ID of the wanted stop (you can get this ID by using a search for stop function)
         - maxInfos: Maximal number of departures which should be returned. It's 10 by default.
         - handler: Gets called when the departures got fetched. The caller can implement further processing of the departures by passing a closure.
     */
    public func getDepartures(route: String, stopId: String, maxInfos: Int = 10, _ completion: (([Departure]) -> Void)) {
        searchURL.path = "/webapp/departures/byroute/" + route + "/" + stopId
        searchURL.queryItems = [URLQueryItem(name: "maxInfos", value: String(maxInfos))]
        if let data = getJsonData() {
            if let departures = Departure.serialize(data) {
                completion(departures)
            }
        }
    }
    
    /**
     Get Departures from a Stop.
     - parameters:
         - stopId: String with ID of the wanted stop (you can get this ID by using a search for stop function)
         - maxInfos: Maximal number of departures which should be returned. It's 10 by default.
         - handler: Gets called when the departures got fetched. The caller can implement further processing of the departures by passing a closure.
     */
    public func getDepartures(stopId: String, maxInfos: Int = 10, _ completion: (([Departure]) -> Void)){
        searchURL.path = "/webapp/departures/bystop/" + stopId
        searchURL.queryItems = [URLQueryItem(name: "maxInfos", value: String(maxInfos))]
        if let data = getJsonData() {
            if let departures = Departure.serialize(data) {
                completion(departures)
            }
        }
    }
    
}
