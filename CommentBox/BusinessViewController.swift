//
//  BusinessViewController.swift
//  Pods-CommentBox
//
//  Created by Dimitrios Philliou on 6/1/18.
//

import GooglePlaces
import UIKit


class BusinessViewController: UIViewController {

    // Dictionary holding business info
    var businessDict : [String: Any] = [:]
    
    //string variable to hold the user's comment
    var comment: String = ""
    
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var businessAddress: UILabel!
    @IBOutlet weak var businessSite: UILabel!

    
    @IBOutlet weak var postComment: UITextView!
    @IBAction func commentButton(_ sender: Any) {
        comment = postComment.text!
        print("Comment: \(comment)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        businessName.text = businessDict["name"] as! String
        businessAddress.text = businessDict["address"] as! String
        businessSite.text = businessDict["website"] as! String
        // Do any additional setup after loading the view.
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
