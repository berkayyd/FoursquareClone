//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by Berkay Demir on 3.04.2024.
//

import Foundation
import UIKit

class PlaceModel {
    
    static let sharedIntance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    private init(){}
    
}
