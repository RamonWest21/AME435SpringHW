//
//  ToDoViewController.swift
//  ToDoList
//
//  Created by student on 3/10/20.
//  Copyright © 2020 Ramon. All rights reserved.
//

import UIKit
import MapKit

class ToDoViewController: UITableViewController, CLLocationManagerDelegate, MKMapViewDelegate  {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePickerView: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationField: UITextField!

    
    var isPickerHidden = true
    var todo: ToDo?
    
    var locationManager: CLLocationManager!
    var locationMapItem: MKMapItem?
    
    func updateSaveButtonState() {
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    func updateDueDateLabel(date: Date) {
        dueDateLabel.text = ToDo.dueDateFormatter.string(from: date )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let todo = todo {
            navigationItem.title = "To-Do"
            titleTextField.text = todo.title
            isCompleteButton.isSelected = todo.isComplete
            dueDatePickerView.date = todo.dueDate
            notesTextView.text = todo.notes
        } else {
            dueDatePickerView.date = Date().addingTimeInterval(24*60*60)
        }
        updateDueDateLabel(date: dueDatePickerView.date)
        updateSaveButtonState()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let normalCellHeight = CGFloat(44)
        let largeCellHeight = CGFloat(200)
        let mapCellHeight = CGFloat(300)
        
        switch(indexPath) {
        case [1,0]:
            return isPickerHidden ? normalCellHeight : largeCellHeight
            
        case [2,0]:
            return largeCellHeight
            
        case [3,0]:
            return mapCellHeight
            
        default: return normalCellHeight
            
        // another case to return large cell height
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath) {
        case [1,0]:
            isPickerHidden = !isPickerHidden
            
            dueDateLabel.textColor = isPickerHidden ? .black : tableView.tintColor
            
            
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default: break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue .identifier == "saveUnwind" else { return }
        
        let title = titleTextField.text!
        let isComplete = isCompleteButton.isSelected
        let dueDate = dueDatePickerView.date
        let notes = notesTextView.text
        
        todo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes)
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        titleTextField.resignFirstResponder()
    }
    
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
        isCompleteButton.isSelected = !isCompleteButton.isSelected
    }
    
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: dueDatePickerView.date)
    }
    
    
    // Location
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        findLocation()
    }
    
    func findLocation() {
        // First, check to see if the user allowed us to use device location.
        if CLLocationManager.locationServicesEnabled() {
            // It takes time to get location, this starts the background process.
            // It does not immediately return a location.
            locationManager.startUpdatingLocation()
        }
    }
//------------------
    @IBAction func annotateButtonTapped(_ sender: UIButton) {
           if self.mapView.overlays.count > 0 {
               self.mapView.removeOverlays(self.mapView.overlays)
           }
           guard let text = locationField.text else {
               print("Empty text field")
               return
           }
           annotateLocation(text: text)
       }
    
    func annotateLocation(text: String) {
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
            self.locationMapItem = MKMapItem(placemark: placemark)

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
//
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



//    // This is used to hide the software keyboard when the user hits return.
//    @IBAction func returnedPressed(_ sender: UITextField) {
//        sender.resignFirstResponder()
//    }
    
//
}

class LocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?

    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}
