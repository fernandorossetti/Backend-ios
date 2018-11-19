//
//  DetailViewController.swift
//  reporTrans
//
//  Created by fernando rossetti on 2/6/17.
//  Copyright © 2017 fernando rossetti. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextView!
    
    
    var report: Report!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typeLabel.text = report.type
        dateLabel.text = report.date
        numberLabel.text = report.number
        commentText.text = report.comment
        imageView.image = UIImage(named: report.score)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
   
    
  

}
