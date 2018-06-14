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
    
    // Label over search bar to hold the business name
    @IBOutlet weak var label: UILabel!
    
    // Dictionary holding all information about a selected business
    var businessDict : [String:Any] = [:]
    
    // Dictionary holding all comments associated with a selected business
    var commentDict : [Int:String] = [:]
    
    // Presents the Autocomplete view controller when the button is pressed.
    // Allows the user to select the location matching their search query
    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    // Segue to the BusinessViewController and send it the businessDict and commentDict
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
        //HTTP GET request to the API to receive all relevant comments
        let commentsURL = "http://167.99.107.99:5000/comments"
        Alamofire.request(commentsURL).responseJSON { response in
            print("\n\n\n\n\n\n - HTTP GET response: \(response)\n\n\n\n\n\n")
            var comment = JSON(response.data!)
            print("json variable: \(comment)")
            for i in 0...comment.count {
                if comment[i]["placeID"].stringValue == businessID {
                    self.commentDict[comment[i]["id"].intValue] = comment[i]["id"].stringValue
                    self.commentDict[comment[i]["text"].intValue] = comment[i]["actual"].stringValue
                    print("comment items matching placeID: \(comment[i])")
                }
            }
        }
        return(self.commentDict)
    }
    
}

extension ViewController: GMSAutocompleteViewControllerDelegate {

    
    // Handle the user's selection.
    // Call Google Places API
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place website: \(place.website)")
        print("Place dictionary: \(place)")
        var placeDict : [String: Any] = ["name": place.name,
                                         "address": place.formattedAddress,
                                         "placeID": place.placeID]
        // Add a website key and value to placeDict if place.website exists
        if place.website != nil {
            placeDict["website"] = place.website!.absoluteString
        }
        
        // Set businessDict in current class to local placeDict
        businessDict = placeDict
        // Initialize commentDict with all the comments returned from downloadComments() function
        commentDict = downloadComments(place.placeID)

        // Set label over search bar to place.name so the user knows their selection was received
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

