//
//  FeedbackViewController.swift
//  Cheaper Goods
//
//  Created by Andrew Kochulab on 11.04.15.
//  Copyright (c) 2015 Andrew Kochulab. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var textField: UITextField!
    
    var previousForm = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.previousForm == "Homepage") {
            self.navigationItem.setLeftBarButtonItem(nil, animated: true)
        }

        self.nameField.layer.cornerRadius = 5.0
        self.nameField.layer.borderColor = UIColor.grayColor().CGColor
        self.nameField.layer.borderWidth = 1.5
        
        self.textField.layer.cornerRadius = 5.0
        self.textField.layer.borderColor = UIColor.grayColor().CGColor
        self.textField.layer.borderWidth = 1.5
    }

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {

        if identifier == "sendReview" {
            
            if nameField.text!.isEmpty {
                let alert = UIAlertView()
                alert.title = NSLocalizedString("FeedbackNameTitle", comment: "")
                alert.message = NSLocalizedString("FeedbackNameMessage", comment: "")
                alert.addButtonWithTitle("Ok")
                alert.show()
                
                return false
            
            } else if textField.text!.isEmpty {
                
                let alert = UIAlertView()
                alert.title = NSLocalizedString("FeedbackTextTitle", comment: "")
                alert.message = NSLocalizedString("FeedbackTextMessage", comment: "")
                alert.addButtonWithTitle("Ok")
                alert.show()
                
                return false

            } else {

                Database.sendAppReview("Feedback", nameField: self.nameField, textField: self.textField)
                return true

            }
        }
        
        // by default, transition
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}