//
//  PlacesVC.swift
//  FoursquareClone
//
//  Created by Berkay Demir on 2.04.2024.
//

import UIKit
import Parse

class PlacesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logOutClicked))
    }
    
    @objc func addButtonClicked() {
        self.performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
    }
    
    @objc func logOutClicked() {
        PFUser.logOutInBackground { error in
            if error != nil {
                let alert = UIAlertController(title: "ERROR!", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else {
                self.performSegue(withIdentifier: "toSignUpVC", sender: nil)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
