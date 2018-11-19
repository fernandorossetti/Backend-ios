//
//  ViewController.swift
//  reporTrans
//
//  Created by fernando rossetti on 2/6/17.
//  Copyright © 2017 fernando rossetti. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SavedReportProtocol {
    
    var report:Report!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var reportar: UIBarButtonItem!
    var reports = [Report]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goToLogin()
        getReports()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
            }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reportCell", forIndexPath: indexPath) as! ReportTableViewCell
        let report = reports[indexPath.row]
        cell.commentLabel.text = report.comment
        cell.dateLabel.text = report.date
        cell.numberLabel.text = report.number
        cell.typeLabel.text = report.type
        cell.scoreIcon.image = UIImage(named: report.score)
        return cell
    }

    func getReports() {
        Request.sharedInstance.getReports { (success, data, error) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.reports.appendContentsOf(data!)
                    self.tableView.reloadData()
                })
            } else {
                let alert = Utils.sharedInstance.createAlert("Error", message: "No se pudieron obtener los reportes")
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func reportDidSave(report: Report) {
        dispatch_async(dispatch_get_main_queue(), {
            self.reports.insert(report, atIndex: 0)
            self.tableView.reloadData()
        })
    }
    
    func goToLogin() {
        let alert = Utils.sharedInstance.createAlert("Alerta", message: "Necesitas iniciar sesion") { (alert) in
             self.performSegueWithIdentifier("loginSegue", sender: self)
        }
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func goToReportView(sender: UIBarButtonItem)
    {
        self.performSegueWithIdentifier("createReportSegue", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createReportSegue" {
            let vc = segue.destinationViewController as! ReportViewController
            vc.delegate = self
        } else if segue.identifier == "detailSegue" {
            let vc = segue.destinationViewController as! DetailViewController
            let index = tableView.indexPathForSelectedRow
            vc.report = reports[index!.row]
        }
    }
    
    @IBAction func Logout(sender: AnyObject) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let token = defaults.stringForKey("Login")
        if token == nil{
            self.dismissViewControllerAnimated(true, completion: nil)
            }
        else {
            let alert = UIAlertController(title: "Alerta", message: "Seguro desea cerrar sesion?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: { action in self.performSegueWithIdentifier("loginSegue", sender: self)} ))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        }

    
        
    
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {}
    

}

