//
//  BusinessViewController.swift
//  Pods-CommentBox
//
//  Created by Dimitrios Philliou on 6/1/18.
//

import Alamofire
import GooglePlaces
import UIKit


class BusinessViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Dictionary holding business info
    var businessDict : [String: Any] = [:]
    
    //Dictionary holding all comments associated with a selected business
    var commentDict : [Int:String] = [:]
    
    //string variable to hold the user's comment
    var comment: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Filling labels with business info
        businessName.text = businessDict["name"] as! String
        businessAddress.text = businessDict["address"] as! String
        if businessDict["website"] != nil {
            businessSite.text = businessDict["website"] as! String
        } else {
            businessSite.text = ""
        }
        
        print("commentDict: \(type(of: commentDict))\n\n\n\n\n\n\n\n\n")
        //Filling list with dictionary values
        for (_, val) in commentDict {
            dataModel.append(val)
        }
        print("dataModel: \(dataModel)\n\n\n\n\n\n\n\n\n")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func postComment(_ comment: String) {
        //API call. Append placeID to the end once routes are setup
        let commentsURL = "http://167.99.107.99:5000/comments"
        let parameters = ["placeID": businessDict["placeID"] as! String, "actual": comment]
        print("parameters: \(parameters)")
        Alamofire.request(commentsURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            print("POST request response: \(response)\n\n\n\n\n\n\n\n\n\n\n")
        }
    }
    
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var businessAddress: UILabel!
    @IBOutlet weak var businessSite: UILabel!

    
    @IBOutlet weak var tableView: UITableView!
    //Declaring an array for the tableView
    var dataModel : [String] = []

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        //Fill the tableView with all of the comments stored in dataModel
        cell.textLabel?.text = dataModel[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textAlignment = .justified
        return cell
    }
    
    @IBOutlet weak var postComment: UITextView!
    @IBAction func commentButton(_ sender: Any) {
        comment = postComment.text!
        postComment(comment)
        print("\n\n\n\n\n\n - Comment: \(comment)\n\n\n\n\n\n")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
