//
//  IntentHandler.swift
//  Extension
//
//  Created by Yury on 10/1/18.
//  Copyright © 2018 Yury Shkoda. All rights reserved.
//

import Intents
import UIKit

class IntentHandler: INExtension, INRidesharingDomainHandling {
    
    func handle(intent: INListRideOptionsIntent, completion: @escaping (INListRideOptionsIntentResponse) -> Void) {
        let result = INListRideOptionsIntentResponse(code: .success, userActivity: nil)
        
        let mini    = INRideOption(name: "Mini Cooper", estimatedPickupDate: Date(timeIntervalSinceNow: 1000))
        let accord  = INRideOption(name: "Honda Accord", estimatedPickupDate: Date(timeIntervalSinceNow: 800))
        let ferrari = INRideOption(name: "Ferrari", estimatedPickupDate: Date(timeIntervalSinceNow: 300))
        ferrari.disclaimerMessage = "This is bad for the enviroment"
        
        result.expirationDate = Date(timeIntervalSinceNow: 3600)
        result.rideOptions = [mini, accord, ferrari]
        
        completion(result)
    }
    
    func handle(intent: INRequestRideIntent, completion: @escaping (INRequestRideIntentResponse) -> Void) {
        let result = INRequestRideIntentResponse(code: .success, userActivity: nil)
        
        let status = INRideStatus()
        // internal value that indentifies the ride uniquely
        status.rideIdentifier = "qwerty"
        // set pick up and drop of location
        status.pickupLocation  = intent.pickupLocation
        status.dropOffLocation = intent.dropOffLocation
        // mark it as confirmed
        status.phase = INRidePhase.confirmed
        // set ETA (15 minutes)
        status.estimatedPickupDate = Date(timeIntervalSinceNow: 900)
        
        // create new vehicle and configure it fully
        let vehicle = INRideVehicle()
        
        // load car image into UIImage, convert that into PNG data, then create an INImage
        if let image = UIImage(named: "car") {
            let data  = UIImage.pngData(image)
            
            if let data = data() { vehicle.mapAnnotationImage = INImage(imageData: data) }
        }
        
        vehicle.location = intent.dropOffLocation!.location
        status.vehicle   = vehicle
        
        // attach INRideStatus object to the result
        result.rideStatus = status
        
        completion(result)
    }
    
    func handle(intent: INGetRideStatusIntent, completion: @escaping (INGetRideStatusIntentResponse) -> Void) {
        let result = INGetRideStatusIntentResponse(code: .success, userActivity: nil)
        completion(result)
    }
    
    func startSendingUpdates(for intent: INGetRideStatusIntent, to observer: INGetRideStatusIntentResponseObserver) {
        
    }
    
    func stopSendingUpdates(for intent: INGetRideStatusIntent) {
        
    }
    
    func handle(cancelRide intent: INCancelRideIntent, completion: @escaping (INCancelRideIntentResponse) -> Void) {
        let result = INCancelRideIntentResponse(code: .success, userActivity: nil)
        completion(result)
    }
    
    func handle(sendRideFeedback sendRideFeedbackintent: INSendRideFeedbackIntent, completion: @escaping (INSendRideFeedbackIntentResponse) -> Void) {
        let result = INSendRideFeedbackIntentResponse(code: .success, userActivity: nil)
        completion(result)
    }
    
    func resolvePickupLocation(for intent: INRequestRideIntent, with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
        let result: INPlacemarkResolutionResult
        
        if let requestedLocation = intent.pickupLocation {
            // pick up location is valid - return success
            result = INPlacemarkResolutionResult.success(with: requestedLocation)
        } else {
            // no pick up location, mark as outstanding
            result = INPlacemarkResolutionResult.needsValue()
        }
        
        completion(result)
    }
    
    func resolveDropOffLocation(for intent: INRequestRideIntent, with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
        let result: INPlacemarkResolutionResult
        
        if let requestedLocation = intent.dropOffLocation {
            result = INPlacemarkResolutionResult.success(with: requestedLocation)
        } else {
            result = INPlacemarkResolutionResult.needsValue()
        }
        
        completion(result)
    }
}
