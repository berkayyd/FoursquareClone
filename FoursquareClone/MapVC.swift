//
//  MapVC.swift
//  FoursquareClone
//
//  Created by Berkay Demir on 3.04.2024.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
    }
    
    @objc func saveButtonClicked() {
        
    }
    
    @objc func backButtonClicked() {
        //navigationController?.popViewController(animated: true)
        //yukarıdakini kullanamayız çünkü navigation controllerdan önce gidebilceği bir yer yok
        self.dismiss(animated: true , completion: nil)
    }
    

}
