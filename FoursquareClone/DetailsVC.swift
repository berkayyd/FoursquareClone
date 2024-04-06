//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Berkay Demir on 3.04.2024.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var detailsImageView: UIImageView!
    
    @IBOutlet weak var detailsNameLabel: UILabel!
    
    @IBOutlet weak var detailsTypeLabel: UILabel!
    
    @IBOutlet weak var detailsAtmosphereLabel: UILabel!
    
    @IBOutlet weak var detailsMapView: MKMapView!
    
    var chosenId = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsMapView.delegate = self
        getDataFromParse()
    }
    
    func getDataFromParse() {
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenId)
        query.findObjectsInBackground { objects , error in
            if error != nil {
                print("ERROR")
            }else {
                
                //OBJECTS
                
                if objects != nil {
                    let chosenPlace = objects![0]
                    
                    if let placeName = chosenPlace.object(forKey: "name") as? String{
                        self.detailsNameLabel.text = placeName
                    }
                    if let placeType = chosenPlace.object(forKey: "type") as? String {
                        self.detailsTypeLabel.text = placeType
                    }
                    if let placeAtmosphere = chosenPlace.object(forKey: "atmosphere") as? String {
                        self.detailsAtmosphereLabel.text = placeAtmosphere
                    }
                    
                    if let latitudeString = chosenPlace.object(forKey: "latitude") as? String {
                        if let latitude = Double(latitudeString) {
                            self.chosenLatitude = latitude
                        } else {
                            print("Error converting latitude to Double")
                        }
                    }

                    if let longitudeString = chosenPlace.object(forKey: "longitude") as? String {
                        if let longitude = Double(longitudeString) {
                            self.chosenLongitude = longitude
                        } else {
                            print("Error converting longitude to Double")
                        }
                    }
                    
                    if let imageData = chosenPlace.object(forKey: "image") as? PFFileObject {
                        imageData.getDataInBackground { data , error in
                            if error == nil {
                                if data != nil {
                                    self.detailsImageView.image = UIImage(data: data!)
                                }
                            }
                        }
                    }
                    
                    //MAP
                    
                    let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                    let region = MKCoordinateRegion(center: location, span: span)
                    self.detailsMapView.setRegion(region, animated: true)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    annotation.title = self.detailsNameLabel.text
                    annotation.subtitle = self.detailsTypeLabel.text
                    self.detailsMapView.addAnnotation(annotation)
                }
            }
            
        }

    }
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        }else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLongitude != 0.0 && self.chosenLatitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            //It uses CLGeocoder() to perform reverse geocoding on the given location, converting the coordinates into a human-readable address (placemark).
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                if let placemark = placemarks {
                //When we write if let placemark = placemarks { }, we're checking if placemarks is not nil.
                if placemark.count > 0 {
                    /*by accessing placemarks[0], we're simply getting the first CLPlacemark object from the array. In many cases, reverse geocoding a location will return only one placemark, but it's possible to receive multiple placemarks if the location corresponds to multiple addresses or points of interest.
                     
                     In this code, it's assumed that we're interested in the first placemark returned by the reverse geocoding operation, so we're accessing it directly. However, in a more robust implementation, you might want to handle cases where there are multiple placemarks returned and choose the most relevant one based on your application's requirements.*/
                    let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                    let mapItem = MKMapItem(placemark: mkPlaceMark)
                    mapItem.name = self.detailsNameLabel.text
                                
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                                
                    mapItem.openInMaps(launchOptions: launchOptions)
                    }
                            
                }
            }
                    
        }
        /*
        guard let annotation = view.annotation else { return }
            
        let placemark = MKPlacemark(coordinate: annotation.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = annotation.title ?? "Destination"
            
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
        */
        
         
    }
}
