//
//  ViewController.swift
//  CommentBox
//
//  Created by Dimitrios Philliou on 5/31/18.
//  Copyright © 2018 Dimitrios. All rights reserved.
//

import Alamofire
import GooglePlaces
import SwiftyJSON
import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    //Dictionary holding all information about a selected business
    var businessDict : [String:Any] = [:]
    
    //Dictionary holding all comments associated with a selected business
    var commentDict : [Int:String] = [:]
    
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
            placeController.commentDict = commentDict
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadComments(_ businessID: String!) -> Dictionary<Int, String> {
        //API call. Append placeID to the end once routes are setup
        let commentsURL = "http://167.99.107.99:5000/comments"
        Alamofire.request(commentsURL).responseJSON { response in
            print("\n\n\n\n\n\n - response: \(response)\n\n\n\n\n\n")
            var json = JSON(response.data!)
            for var i in 0...json.count {
                if json[i]["placeID"].stringValue == businessID {
                    self.commentDict[json[i]["id"].intValue] = json[i]["actual"].stringValue
                    print("json[i]: \(json[i])")
                }
            }
        }
        return(self.commentDict)
    }
    
}

extension ViewController: GMSAutocompleteViewControllerDelegate {

    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place website: \(place.website)")
        print("Place dictionary: \(place)")
        var placeDict : [String: Any] = ["name": place.name,
                                         "address": place.formattedAddress,
                                         //"website": place.website!.absoluteString,
                                         "placeID": place.placeID]

        if place.website != nil {
            placeDict["website"] = place.website!.absoluteString
        }
        //let placeDict["website"] = place.website ?? ""
        //App crashes if place.website == nil. Need to debug.
        
        businessDict = placeDict
        commentDict = downloadComments(place.placeID)

        label.text = " " + place.name
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

