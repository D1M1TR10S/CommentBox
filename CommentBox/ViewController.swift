//
//  ViewController.swift
//  CommentBox
//
//  Created by Dimitrios Philliou on 5/31/18.
//  Copyright © 2018 Dimitrios. All rights reserved.
//

import UIKit
import GooglePlaces

class ViewController: UIViewController {
    
    //@IBOutlet weak var placeLabel: UILabel!
    //Label over search bar. Should fill with place.name after GMS Autocomplete window is dismissed.
    
    var businessDict : [String:Any] = [:]
    //HOW DO WE INITIALIZE THIS DICT FROM THE RESULTS OF THE GOOGLE PLACES EXTENSION??
    
    // Presents the Autocomplete view controller when the button is pressed.
    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "businessSegue" {
            let placeController = segue.destination as! BusinessViewController
            placeController.businessDict = businessDict
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place website: \(place.website)")
        let placeDict : [String: Any] = ["name": place.name,
                                         "address": place.formattedAddress,
                                         "website": place.website!.absoluteString]
        businessDict = placeDict
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

