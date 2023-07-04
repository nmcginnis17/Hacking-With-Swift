//
//  IntentHandler.swift
//  Extension
//
//  Created by Nicholas McGinnis on 7/2/23.
//

import Intents
import UIKit

class IntentHandler: INExtension, INListRideOptionsIntentHandling, INRequestRideIntentHandling, INGetRideStatusIntentHandling, INCancelRideIntentHandling, INSendRideFeedbackIntentHandling {
    func handle(intent: INListRideOptionsIntent, completion: @escaping (INListRideOptionsIntentResponse) -> Void) {
        // list of rides available
        let result = INListRideOptionsIntentResponse(code: .success, userActivity: nil)
        
        let mini = INRideOption(name: "Mini Cooper", estimatedPickupDate: Date(timeIntervalSinceNow: 1000))
        let honda = INRideOption(name: "Honda Accord", estimatedPickupDate: Date(timeIntervalSinceNow: 800))
        let ferrari = INRideOption(name: "Ferrari F430", estimatedPickupDate: Date(timeIntervalSinceNow: 300))
        ferrari.disclaimerMessage = "This is a bad car. You should feel bad."
        
        result.expirationDate = Date(timeIntervalSinceNow: 3600)
        result.rideOptions = [mini, honda, ferrari]
        
        completion(result)
    }
    
    func handle(intent: INRequestRideIntent, completion: @escaping (INRequestRideIntentResponse) -> Void) {
        // ride has been requested using Maps or Siri
        let result = INRequestRideIntentResponse(code: .success, userActivity: nil)
        
        let status = INRideStatus()
        
        //internal value to identify ride uniquely in backend system
        status.rideIdentifier = "abc123"
        
        // assign pickup and dropoff locations we agreed upon
        status.pickupLocation = intent.pickupLocation
        status.dropOffLocation = intent.dropOffLocation
        
        // mark as confirmed by rider
        status.phase = INRidePhase.confirmed
        
        // time till ride arrives
        status.estimatedPickupDate = Date(timeIntervalSinceNow: 900)
        
        // create new vehicle and configure fully
        let vehicle = INRideVehicle()
        
        // workaround: load car image into UIImage, convert into PNG data, then create the INImage
        let image = UIImage(named: "car")!
        let data = image.pngData()!
        vehicle.mapAnnotationImage = INImage(imageData: data)
        
        // set vehicle's current location to wherever user wants to go - this should place it a little way away for testing
        vehicle.location = intent.dropOffLocation?.location
        
        // once vehicle is fully configured, assign it all at once to status.vehicle
        status.vehicle = vehicle
        
        // attach finished INRideStatus object to result
        result.rideStatus = status
        
        // send back
        completion(result)
    }
    
    func handle(intent: INGetRideStatusIntent, completion: @escaping (INGetRideStatusIntentResponse) -> Void) {
        // get ride status
        /// called when user asks where their ride is, connect to your server to get current location of ride and send it back
        let result = INGetRideStatusIntentResponse(code: .success, userActivity: nil)
        completion(result)
    }
    
    func startSendingUpdates(for intent: INGetRideStatusIntent, to observer: INGetRideStatusIntentResponseObserver) {
        //
    }
    
    func stopSendingUpdates(for intent: INGetRideStatusIntent) {
        //
    }
    
    func handle(cancelRide intent: INCancelRideIntent, completion: @escaping (INCancelRideIntentResponse) -> Void) {
        // cancel ride request
        /// connect to your server
        let result = INCancelRideIntentResponse(code: .success, userActivity: nil)
        completion(result)
    }
    
    func handle(sendRideFeedback sendRideFeedbackintent: INSendRideFeedbackIntent, completion: @escaping (INSendRideFeedbackIntentResponse) -> Void) {
        // leave review for driver
        /// connect to your server
        let result = INSendRideFeedbackIntentResponse(code: .success, userActivity: nil)
        completion(result)
    }
    
    func resolvePickupLocation(for intent: INRequestRideIntent, with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
        // return success if valid pickup location or request a valid one
        let result: INPlacemarkResolutionResult
        
        if let requestedLocation = intent.pickupLocation {
            // we have a valid pickup location
            result = INPlacemarkResolutionResult.success(with: requestedLocation)
        } else {
            // no pickup location
            result = INPlacemarkResolutionResult.needsValue()
        }
        
        completion(result)
    }
    
    func resolveDropOffLocation(for intent: INRequestRideIntent, with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
        // return success if valid dropoff location or request a valid one
        let result: INPlacemarkResolutionResult
        
        if let requestedLocation = intent.dropOffLocation {
            // valid dropoff location
            result = INPlacemarkResolutionResult.success(with: requestedLocation)
        } else {
            // no dropoff location
            result = INPlacemarkResolutionResult.needsValue()
        }
        
        completion(result)
    }
    
    
}
