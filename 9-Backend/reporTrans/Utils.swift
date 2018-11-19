//
//  Utils.swift
//  reporTrans
//
//  Created by fernando rossetti on 2/6/17.
//  Copyright © 2017 fernando rossetti. All rights reserved.
//

import UIKit

typealias handlerAlert = (alert: UIAlertAction) -> ()

struct Utils {
    static let sharedInstance = Utils()
    
    private init () {}
    
    func createAlert(title: String, message: String?, handler: handlerAlert? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Aceptar", style: .Default, handler: handler)
        alert.addAction(action)
        return alert
    }
}