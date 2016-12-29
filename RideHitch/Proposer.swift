//
//  Proposer.swift
//  Lady
//
//  Created by NIX on 15/7/11.
//  Copyright (c) 2015年 nixWork. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import AddressBook
import CoreLocation

public enum PrivateResource {
    case photos
    case camera
    case microphone


    public enum LocationUsage {
        case whenInUse
        case always
    }
    case location(LocationUsage)

    public var isNotDeterminedAuthorization: Bool {
        switch self {
        case .photos:
            return PHPhotoLibrary.authorizationStatus() == .notDetermined
        case .camera:
            return AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == .notDetermined
        case .microphone:
            return AVAudioSession.sharedInstance().recordPermission() == .undetermined
        case .location:
            return CLLocationManager.authorizationStatus() == .notDetermined
        }
    }
}

public typealias Propose = () -> Void

public typealias ProposerAction = () -> Void

public func proposeToAccess(_ resource: PrivateResource, agreed successAction: @escaping ProposerAction, rejected failureAction: @escaping ProposerAction) {

    switch resource {

    case .photos:
        proposeToAccessPhotos(agreed: successAction, rejected: failureAction)

    case .camera:
        proposeToAccessCamera(agreed: successAction, rejected: failureAction)

    case .microphone:
        proposeToAccessMicrophone(agreed: successAction, rejected: failureAction)


    case .location(let usage):
        proposeToAccessLocation(usage, agreed: successAction, rejected: failureAction)
    }
}

private func proposeToAccessPhotos(agreed successAction: @escaping ProposerAction, rejected failureAction: @escaping ProposerAction) {
    PHPhotoLibrary.requestAuthorization { status in
        DispatchQueue.main.async {
            switch status {
            case .authorized:
                successAction()
            default:
                failureAction()
            }
        }
    }
}

private func proposeToAccessCamera(agreed successAction: @escaping ProposerAction, rejected failureAction: @escaping ProposerAction) {
    AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { granted in
        DispatchQueue.main.async {
            granted ? successAction() : failureAction()
        }
    }
}

private func proposeToAccessMicrophone(agreed successAction: @escaping ProposerAction, rejected failureAction: @escaping ProposerAction) {
    AVAudioSession.sharedInstance().requestRecordPermission { granted in
        DispatchQueue.main.async {
            granted ? successAction() : failureAction()
        }
    }
}



private var _locationManager: CLLocationManager? // as strong ref

private func proposeToAccessLocation(_ locationUsage: PrivateResource.LocationUsage, agreed successAction: @escaping ProposerAction, rejected failureAction: @escaping ProposerAction) {

    switch CLLocationManager.authorizationStatus() {

    case .authorizedWhenInUse:
        if locationUsage == .whenInUse {
            successAction()
        } else {
            failureAction()
        }

    case .authorizedAlways:
        successAction()

    case .notDetermined:
        if CLLocationManager.locationServicesEnabled() {

            let locationManager = CLLocationManager()
            _locationManager = locationManager

            let delegate = LocationDelegate(locationUsage: locationUsage, successAction: successAction, failureAction: failureAction)
            _locationDelegate = delegate

            locationManager.delegate = delegate

            switch locationUsage {

            case .whenInUse:
                locationManager.requestWhenInUseAuthorization()

            case .always:
                locationManager.requestAlwaysAuthorization()
            }

            locationManager.startUpdatingLocation()

        } else {
            failureAction()
        }

    default:
        failureAction()
    }
}

// MARK: LocationDelegate

private var _locationDelegate: LocationDelegate? // as strong ref

class LocationDelegate: NSObject, CLLocationManagerDelegate {

    let locationUsage: PrivateResource.LocationUsage
    let successAction: ProposerAction
    let failureAction: ProposerAction

    init(locationUsage: PrivateResource.LocationUsage, successAction: @escaping ProposerAction, failureAction: @escaping ProposerAction) {
        self.locationUsage = locationUsage
        self.successAction = successAction
        self.failureAction = failureAction
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        DispatchQueue.main.async {

            switch status {

            case .authorizedWhenInUse:
                self.locationUsage == .whenInUse ? self.successAction() : self.failureAction()

                _locationManager = nil
                _locationDelegate = nil

            case .authorizedAlways:
                self.locationUsage == .always ? self.successAction() : self.failureAction()

                _locationManager = nil
                _locationDelegate = nil

            case .denied:
                self.failureAction()

                _locationManager = nil
                _locationDelegate = nil

            default:
                break
            }
        }
    }
}

