//
//  ViewController.swift
//  LocationApp
//
//  Created by Loren Olson on 2/19/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // outlets from the storyboard
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationFieldA: UITextField!
    @IBOutlet weak var locationFieldB: UITextField!
    
    
    // Location manager needed by CoreLocation, to get device location.
    var locationManager: CLLocationManager!
    
    
    // Route feature demo
    // These properties are used to save location information during the
    // multi-step process to create a route.
    var locationAMapItem: MKMapItem?
    var locationBMapItem: MKMapItem?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupLocationServices()
        locationFieldA.text = "Sun Devil Stadium"
        locationFieldB.text = "Salt River Fields"
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }


    @IBAction func routeButtonTapped(_ sender: UIButton) {
        guard let textA = locationFieldA.text, let textB = locationFieldB.text else {
            print("Empty text fields")
            return
        }
        guard textA.isEmpty == false, textB.isEmpty == false else {
            print("Need two location strings.")
            return
        }
        geocodeLocationA(text: textA)
    }
    
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        findLocation()
    }
    
    
    @IBAction func annotateButtonTapped(_ sender: UIButton) {
        if self.mapView.overlays.count > 0 {
            self.mapView.removeOverlays(self.mapView.overlays)
        }
        guard let textA = locationFieldA.text else {
            print("Empty text field")
            return
        }
        annotateLocationA(text: textA)
    }
    
    
    @IBAction func trashButtonTapped(_ sender: UIButton) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
    }
    
    
    
    // Find the current device location
    func findLocation() {
        // First, check to see if the user allowed us to use device location.
        if CLLocationManager.locationServicesEnabled() {
            // It takes time to get location, this starts the background process.
            // It does not immediately return a location.
            locationManager.startUpdatingLocation()
        }
    }
    
    
    // Given a string as input, lookup a location based on that string.
    // If found, center the map, and make an annotation.
    // Notice that all the results happen in a closure.
    func annotateLocationA(text: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(text, completionHandler: { (placemarks, error) in
            guard let place = placemarks?.first!, let location = place.location else {
                if let error = error {
                    print(error.localizedDescription)
                }
                print("Unable to geocode: \(text)")
                return
            }
            print("Geocoded \(text)")
            let placemark = MKPlacemark(coordinate: location.coordinate)
            self.locationAMapItem = MKMapItem(placemark: placemark)
            
            // Center and zoom the map display
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            
            /*
             * Simple pin example
            let pin: MKPointAnnotation = MKPointAnnotation()
            pin.coordinate = center
            self.mapView.addAnnotation(pin)
            */
            
            let pointOfInterest = LocationAnnotation(coordinate: center, title: text)
            self.mapView.addAnnotation(pointOfInterest)
            
        })
    }
    
    
    // This is step 1 in the process of creating a route from point A to point B.
    // First, see if a location is found for point A. If that works, then move on
    // to step 2 (finding point B)
    func geocodeLocationA(text: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(text, completionHandler: { (placemarks, error) in
            guard let place = placemarks?.first!, let location = place.location else {
                if let error = error {
                    print(error.localizedDescription)
                }
                print("Unable to geocode: \(text)")
                return
            }
            print("Geocoded \(text)")
            let placemark = MKPlacemark(coordinate: location.coordinate)
            self.locationAMapItem = MKMapItem(placemark: placemark)
            
            if let textB = self.locationFieldB.text {
                self.geocodeLocationB(text: textB)
            }
        })
    }
    
    
    // This is step 2 in the process of creating a route from point A to point B.
    // See if a location is found for point B. If that works, then move on to
    // step 3. (Find the route)
    func geocodeLocationB(text: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(text, completionHandler: { (placemarks, error) in
            guard let place = placemarks?.first!, let location = place.location else {
                if let error = error {
                    print(error.localizedDescription)
                }
                print("Unable to geocode: \(text)")
                return
            }
            print("Geocoded \(text)")
            let placemark = MKPlacemark(coordinate: location.coordinate)
            self.locationBMapItem = MKMapItem(placemark: placemark)
            self.route()
        })
    }
    
    
    // This step 3 in the process of creating a route from point A to point B.
    // Now that point A and point B have been found, make a request to find
    // a route from A to B.
    func route() {
        if self.mapView.overlays.count > 0 {
            self.mapView.removeOverlays(self.mapView.overlays)
        }
        let request = MKDirections.Request()
        request.source = locationAMapItem
        request.destination = locationBMapItem
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate(completionHandler: {(response: MKDirections.Response?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let response = response {
                guard response.routes.count > 0 else { return }
                var routes = response.routes
                routes.sort(by: {$0.expectedTravelTime < $1.expectedTravelTime})
                let route = routes[0]
                
                self.mapView.addOverlay(route.polyline)
                
                if self.mapView.overlays.count == 1 {
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0), animated: false)
                }
                else {
                    let polylineBoundingRect =  self.mapView.visibleMapRect.union(route.polyline.boundingMapRect)
                    self.mapView.setVisibleMapRect(polylineBoundingRect,
                                                   edgePadding: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0),
                                              animated: false)
                }
                
            }
        })
    }
    
    
    
    // MARK: - MKMapViewDelegate
    
    // A mapview delegate method, this is used to set the appearance of map overlaps.
    // This is required by the route feature - drawing the blue line from point A to point B.
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if (overlay is MKPolyline) {
            if mapView.overlays.count == 1 {
                polylineRenderer.strokeColor = UIColor.blue.withAlphaComponent(0.75)
            }
            polylineRenderer.lineWidth = 5
        }
        return polylineRenderer
    }
    
    
    // A mapview delegate method. Used to create an annotation view, based on our custom LocationAnnotation object.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = MKMarkerAnnotationView()
        guard let annotation = annotation as? LocationAnnotation else { return nil }
        let identifier = "LocationAnnotationID"
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            annotationView = dequedView
            annotationView.annotation = annotation
        }
        else {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView.titleVisibility = .visible
        annotationView.clusteringIdentifier = identifier
        return annotationView
    }
    
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager failed: \(error.localizedDescription)")
    }
    
    
    // Location manager delegate method. After we start the location updates, when the device has been located, this
    // will get called.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locationManger:didUpdateLocations")
        // Now that we got the location, turn off location updates so we don't waste battery.
        locationManager.stopUpdatingLocation()
        let userLocation: CLLocation = locations[0] as CLLocation
        
        // Center and zoom the map display
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        
        // Add an annotation
        let pointOfInterest = LocationAnnotation(coordinate: center, title: "Current Location")
        self.mapView.addAnnotation(pointOfInterest)
    }
    
    
    // MARK: - Setup Location Services
    // Setup to use the location services api. Just do this one time after the viewcontroller starts up.
    func setupLocationServices() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    
    // This is used to hide the software keyboard when the user hits return.
    @IBAction func returnedPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    
}


// A custom object to hold information for an annotation.
class LocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}

