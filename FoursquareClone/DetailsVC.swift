//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Berkay Demir on 3.04.2024.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController {

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

}
