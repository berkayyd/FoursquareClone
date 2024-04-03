//
//  AddPlaceVC.swift
//  FoursquareClone
//
//  Created by Berkay Demir on 3.04.2024.
//

import UIKit

class AddPlaceVC: UIViewController {

    @IBOutlet weak var placeNameText: UITextField!
    
    @IBOutlet weak var placeTypeText: UITextField!
    
    @IBOutlet weak var placeAtmosphereText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func nextButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toMapVC", sender: nil)
    }
    
}
