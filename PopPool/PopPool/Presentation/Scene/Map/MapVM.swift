//
//  MapVM.swift
//  PopPool
//
//  Created by 김기현 on 8/6/24.
//

import Foundation
import RxSwift
import CoreLocation

class MapVM {
    private let locationManager = CLLocationManager()
    private let disposeBag = DisposeBag()

    init() {
        setupLocationManager()
    }

    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func getCurrentLocation() -> Observable<CLLocationCoordinate2D?> {
        return Observable.create { observer in
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.requestLocation()
                if let location = self.locationManager.location {
                    observer.onNext(location.coordinate)
                    observer.onCompleted()
                } else {
                    observer.onNext(nil)
                    observer.onCompleted()
                }
            } else {
                observer.onNext(nil)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    func searchLocation(query: String) -> Observable<CLLocationCoordinate2D?> {
        return Observable.create { observer in
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(query) { placemarks, error in
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                    observer.onNext(nil)
                    observer.onCompleted()
                    return
                }

                if let location = placemarks?.first?.location?.coordinate {
                    observer.onNext(location)
                } else {
                    observer.onNext(nil)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
