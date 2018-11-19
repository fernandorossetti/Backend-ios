//
//  Request.swift
//  reporTrans
//
//  Created by fernando rossetti on 2/6/17.
//  Copyright © 2017 fernando rossetti. All rights reserved.
//

import Foundation
import Alamofire

typealias CompletionHandlerGetReports = (success: Bool, data: [Report]?, error: String?) -> ()

typealias CompletionHandlerPost = (success: Bool, error: String?) -> ()

struct Request {
    static let sharedInstance = Request()
    
    private let staticUrl = "https://baas.kinvey.com/"
    private let reportsUrl = "appdata/kid_Hy3_F-OFg/Report"
    private let authHeaders = ["Authorization": "Basic a2lkX0h5M19GLU9GZzpmMjA1ZTUwYTZkYjE0ZDc1OTk0MjI5MDJjMjRmYWI5OQ=="]
    private let basic = "kid_Hy3_F-OFg:3bf4d4f431ee4c609032b1de52030a76"
    
    private init() {}
    
    func getReports(completion: CompletionHandlerGetReports) {
        let params: [String: AnyObject] = [ "sort": "{\"_kmd\": -1}" ]
        let url = "\(staticUrl)\(reportsUrl)"
        
        request(.GET, url, parameters: params, headers: authHeaders)
            .responseJSON { (response) in
                print(response.request!)
                switch response.result {
                case .Success(let JSON):
                    let data = JSON as! [[String : AnyObject]]
                    
                    let reports = data.map({ (report) -> Report in
                        let type = report["type"] as! String
                        let number = report["number"] as! String
                        let date = report["date"] as! String
                        let score = report["score"] as! String
                        let comment = report["comment"] as! String
                        return Report(number: number, date: date, score: score, comment: comment, type: type)
                    })
                    
                    completion(success: true, data: reports, error: nil)
                case .Failure(let error):
                    completion(success: false, data: nil, error: error.localizedDescription)
                }
        }
    }
    
    func saveReport(report: Report, completion: CompletionHandlerPost) {
        let params = ["type": report.type, "number": report.number, "date": report.date, "score": report.score, "comment": report.comment]
        
        request(.POST, staticUrl + reportsUrl, parameters: params,headers: authHeaders)
            .responseJSON { (reponse) in
                switch reponse.result {
                case .Success(_):
                    completion(success: true, error: nil)
                case .Failure(let error):
                    completion(success: false, error: error.localizedDescription)
                }
        }
    }
    
    func loginUser(username: String, password: String, completion: CompletionHandlerPost) {
        
        let headers = ["Authorization": "Basic \(base64Encode(basic))"]
        let url = staticUrl + "user/kid_Hy3_F-OFg/login"
        let params = ["username": username, "password": password]
        
        request(.POST, url, parameters: params,headers: headers)
            .responseJSON { (reponse) in
                switch reponse.result {
                case .Success(let json):
                    let data = json as! [String : AnyObject]
                    if let error = data["error"] as? String {
                        completion(success: false, error: error)
                    } else {
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setValue("true", forKey: "Login")
                        completion(success: true, error: nil)
                    }
                case .Failure(let error):
                    completion(success: false, error: error.localizedDescription)
                }
        }
    }
    
    func registerUser(username: String, password: String, completion: CompletionHandlerPost) {
        let headers = ["Authorization": "Basic \(base64Encode(basic))"]
        let params = ["username": username, "password": password]
        let url = staticUrl + "user/kid_Hy3_F-OFg/"
        
        request(.POST, url, parameters: params, headers: headers)
            .responseJSON { (reponse) in
                switch reponse.result {
                case .Success(let json):
                    let data = json as! [String : AnyObject]
                    if let error = data["error"] as? String {
                        completion(success: false, error: error)
                    } else {
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setValue("true", forKey: "Login")
                        completion(success: true, error: nil)
                    }
                case .Failure(let error):
                    completion(success: false, error: error.localizedDescription)
                }
        }
    }
    
    private func base64Encode(token: String) -> String{
        let utf8str = token.dataUsingEncoding(NSUTF8StringEncoding)
        let data = utf8str!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        return data
    }
}