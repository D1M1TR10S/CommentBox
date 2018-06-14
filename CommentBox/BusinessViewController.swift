//
//  BusinessViewController.swift
//  Pods-CommentBox
//
//  Created by Dimitrios Philliou on 6/1/18.
//

import Alamofire
import GooglePlaces
import UIKit


class BusinessViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    // Dictionary holding business info
    var businessDict : [String: Any] = [:]
    
    //Dictionary holding all comments associated with a selected business
    var commentDict : [Int:String] = [:]
    
    //string variable to hold the user's comment
    var comment: String = ""
    
    //Declaring label outlets to dynamically produce business info
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var businessAddress: UILabel!
    @IBOutlet weak var businessSite: UILabel!
    @IBOutlet var ScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initializing labels with business info to produce the business page dynamically
        businessName.text = businessDict["name"] as! String
        businessAddress.text = businessDict["address"] as! String
        if businessDict["website"] != nil {
            businessSite.text = businessDict["website"] as! String
        } else {
            businessSite.text = ""
        }
        
        //Filling list with dictionary values
        for (_, val) in commentDict {
            dataModel.append(val)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func postComment(_ comment: String) {
        //HTTP POST request to the CommentBox comments database
        let commentsURL = "http://167.99.107.99:5000/comments"
        let parameters = ["placeID": businessDict["placeID"] as! String, "actual": comment]
        print("parameters: \(parameters)")
        Alamofire.request(commentsURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            print("POST response: \(response)\n\n\n\n\n\n\n\n\n\n\n")
        }
    }
    

    @IBOutlet weak var tableView: UITableView!
    //Declaring an array to populate the tableView with comments
    var dataModel : [String] = []

    //Declaring tableview functionalities
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
    
    @IBAction func upvote(_ sender: UIButton) {
        
    }
    
    // Outlets connecting to the comment TextView
    // Scrolls the ScrollView up when keyboard is present
    @IBOutlet weak var postComment: UITextView!
    func textViewDidBeginEditing(_ textView: UITextView) {
        ScrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        ScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    
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
