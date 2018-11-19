//
//  ReportViewController.swift
//  reporTrans
//
//  Created by fernando rossetti on 2/6/17.
//  Copyright © 2017 fernando rossetti. All rights reserved.

//

import UIKit

protocol SavedReportProtocol {
    func reportDidSave(report: Report)
}

class ReportViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var numberLabel: UITextField!
    @IBOutlet weak var typeOfVehicle: UISegmentedControl!
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var scoreSegment: UISegmentedControl!
    
    var delegate : SavedReportProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentText.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendReport(sender: UIBarButtonItem) {
        guard checkParams() == true else {
            let alert = Utils.sharedInstance.createAlert("Error", message: "Necesitas llenar todos los campos")
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let vehicle = getVehicle(typeOfVehicle.selectedSegmentIndex.hashValue)
        let score = getScore(scoreSegment.selectedSegmentIndex.hashValue)
        let number = numberLabel.text
        let comment = commentText.text
        
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        let date = formater.stringFromDate(NSDate())
        
        let report = Report(number: number!, date: date, score: score, comment: comment, type: vehicle)
        
        Request.sharedInstance.saveReport(report) { (success, error) in
            if success {
                self.delegate.reportDidSave(report)
                self.performSegueWithIdentifier("backToReportsSegue", sender: self)
            } else {
                let alert = Utils.sharedInstance.createAlert("Error", message: error)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func endTexting(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func checkParams() -> Bool {
        guard numberLabel.text != "" else {
            return false
        }
        
        guard commentText.text != "" else {
            return false
        }
        return true
    }
    
    func getScore(index: Int) -> String {
        let option = Score(rawValue: index)!
        switch option {
        case .Bad:
            return "malo"
        case .Good:
            return "bueno"
        }
    }
    
    func getVehicle(index: Int) -> String {
        let option = TypeVehicle(rawValue: index)!
        switch option {
        case .Bus:
            return "Bus"
        case .MicroBus:
            return "MicroBus"
        case .Taxi:
            return "Taxi"
        }
    }
    @IBAction func unwindToReports(segue: UIStoryboardSegue) {}

}
