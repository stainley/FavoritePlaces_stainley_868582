//
//  MapPlaceViewController.swift
//  favoritePlaces_stainley_868582
//
//  Created by Stainley A Lebron R on 2023-01-24.
//

import UIKit
import MapKit

class MapPlaceViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    var location: CLLocationManager!
    var locationManager = CLLocationManager()
    
    var placeEntity: PlaceEntity?
    
    // context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        
        map.isZoomEnabled = true
        map.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotationByTapping))
        map.addGestureRecognizer(tapGesture)
       
        map.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard placeEntity != nil else {
            return
        }
        
        let myPlace = PlaceAnnotation()
        myPlace.coordinate = CLLocationCoordinate2D(latitude: placeEntity?.latitude ?? 0.0, longitude: placeEntity?.longitude ?? 0.0)
        myPlace.postalCode = placeEntity?.postalCode
        myPlace.locality = placeEntity?.locality
        map.addAnnotation(myPlace)
    }
    
    
    @objc func addAnnotationByTapping(gesture: UIGestureRecognizer) {
        let touchPoint = gesture.location(in: map)
        let coordinate = map.convert(touchPoint, toCoordinateFrom: map)
        
        addMyAnnotation(coordinate: coordinate)
    }
    
    func addMyAnnotation(coordinate: CLLocationCoordinate2D) {
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), completionHandler:  {(placemarks, error) in
            
            if error != nil {
                print(error!)
            } else {
                DispatchQueue.main.async {
                    if let placeMark = placemarks?[0] {
                        let placeAnnotation = PlaceAnnotation()
                        placeAnnotation.title = "Place to visit"
                        placeAnnotation.coordinate = coordinate
                        if placeMark.locality != nil {
                            placeAnnotation.locality = placeMark.locality!
                        }
                        if placeMark.postalCode != nil {
                            placeAnnotation.postalCode = placeMark.postalCode!
                        }
                        
                        self.map.addAnnotation(placeAnnotation)
                    }
                }
            }
        })
    }
    
    @IBAction func searchLocationButton(_ sender: UIBarButtonItem) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    
    func displayLocation(latitude: CLLocationDegrees,
                         longitude: CLLocationDegrees,
                         title: String,
                         subtitle: String) {
        
        let latitudeDelta: CLLocationDegrees = 0.7
        let longitudeDelta: CLLocationDegrees = 0.7
        
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        
        map.setRegion(region, animated: true)
        
    }

}

extension MapPlaceViewController: CLLocationManagerDelegate {
    
    //MARK: show updating location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations[0]
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        displayLocation(latitude: latitude, longitude: longitude, title: "My Location", subtitle:  "I'm  here")
    }
}


extension MapPlaceViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView: MKAnnotationView?
        if let annotation = annotation as? PlaceAnnotation {
            annotationView = setupCustomAnnotationView(for: annotation, on: map)
        }

        return annotationView
    }
    
    private func setupCustomAnnotationView(for annotation: PlaceAnnotation, on mapView: MKMapView) -> MKAnnotationView {

        let flagAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "custom_place")
        flagAnnotationView.canShowCallout = true
   
        // Provide the left image icon for the annotation.
        flagAnnotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        return flagAnnotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let placeAnnotation = view.annotation as! PlaceAnnotation
        let placeLocality = placeAnnotation.locality

        let calloutAction = UIAlertController(title: placeLocality, message: "placeInfo", preferredStyle: .alert)
        // Save into Core Data when user press SAVE
        calloutAction.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) -> () in
            print("SAVE VALUE IN CORE DATA")
            
            let placeEntity = PlaceEntity(context: self.context)
            
            placeEntity.locality = placeLocality
            placeEntity.postalCode = placeAnnotation.postalCode
            placeEntity.latitude = placeAnnotation.coordinate.latitude
            placeEntity.longitude = placeAnnotation.coordinate.longitude
            
            self.savePlace()
            print("Place \(placeLocality!) has been saved!!!")
            
        }))
        present(calloutAction, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
    }
}


extension MapPlaceViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: request)
        activeSearch.start {
            (response, error) in
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil {
                print(error!)
            } else {
                
                guard let coordinate = response?.mapItems[0].placemark.coordinate else {
                    return
                }
                
                guard (response?.mapItems[0].name) != nil else {
                    return
                }
                
                let lat = coordinate.latitude
                let lon = coordinate.longitude
                
                //self.addMyAnnotation(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))

            }
        }
    }
}
