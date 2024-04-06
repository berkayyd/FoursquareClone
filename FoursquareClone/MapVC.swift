//
//  MapVC.swift
//  FoursquareClone
//
//  Created by Berkay Demir on 3.04.2024.
//

import UIKit
import MapKit
import Parse

class MapVC: UIViewController , MKMapViewDelegate , CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer: )))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
    }
    
    @objc func chooseLocation(gestureRecognizer : UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedIntance.placeName
            annotation.subtitle = PlaceModel.sharedIntance.placeType
            
            self.mapView.addAnnotation(annotation)
            
            PlaceModel.sharedIntance.placeLatitude = String(coordinates.latitude)
            PlaceModel.sharedIntance.placeLongitude = String(coordinates.longitude)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            //locationManager.stopUpdatingLocation()
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }
    
    // Assuming you have a method to handle custom location selection
    func didSelectCustomLocation(_ location: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }

    
    @objc func saveButtonClicked() {
        
        let placeModel = PlaceModel.sharedIntance
        var object = PFObject(className: "Places")
        
        object["name"] = placeModel.placeName
        object["type"] = placeModel.placeType
        object["atmosphere"] = placeModel.placeAtmosphere
        object["latitude"] = placeModel.placeLatitude
        object["longitude"] = placeModel.placeLongitude
        
        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5) {
            object["image"] = PFFileObject(name: "images.jpg", data: imageData)
        }
        
        object.saveInBackground { success, error in
            if error != nil {
                let error = UIAlertController(title: "ERROR!", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                error.addAction(okButton)
                self.present(error, animated: true, completion: nil)
            }else {
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
        }
    }
    
    @objc func backButtonClicked() {
        //navigationController?.popViewController(animated: true)
        //yukarıdakini kullanamayız çünkü navigation controllerdan önce gidebilceği bir yer yok
        self.dismiss(animated: true , completion: nil)
    }
    

}
