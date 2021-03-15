//
//  BaseApi.swift
//  LMS
//
//  Created by Reinforce on 09/12/19.
//  Copyright © 2019 Reinforce. All rights reserved.
//

import Foundation
import UIKit

class BaseApi {
    
    static var VC = UIViewController()
  
    static var customLoaderView:CustomLoaderView!
    static let window = (UIApplication.shared.delegate as! AppDelegate).window
    static var isLoaderShowing = false
    
    static func showActivityIndicator(icon:UIImage?, text:String){
        
        if !isLoaderShowing{
            customLoaderView = CustomLoaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), icon: icon, loaderText: text)
            window?.addSubview(customLoaderView)
        }
    }
    static func hideActivirtIndicator(){
        if((customLoaderView) != nil){
            customLoaderView.hide()
            
            customLoaderView.removeFromSuperview()
            
        }
        isLoaderShowing = false
    }

    
    
    static func callApiRequestForGet(url : String, completionHandler: @escaping (_ result: Any, _ error: String) -> Void){
          
          var searchURL = NSURL()
          if let url = NSURL(string: "\(url)")
          {
              searchURL = url
          }
          else {
              let Nurl : NSString = url as NSString
//Globalfunc.print(object: Nurl)
              let urlStr : NSString = Nurl.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
              searchURL = NSURL(string: urlStr as String)!
             // Globalfunc.print(object: searchURL)
          }
          
            var request = URLRequest(url: searchURL as URL)
            if let authToken = userDef.value(forKey: "authToken") {
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("\(authToken)", forHTTPHeaderField: "Authorization")

        }
          
          
          URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
             if let httpStatus = response as? HTTPURLResponse,
                 httpStatus.statusCode == 401 { // check for httperrors
                 if let parsedData = try? JSONSerialization.jsonObject(with: data!)
                 {
                    // Globalfunc.print(object:parsedData)
                     let dd = parsedData as! NSDictionary
                     let msg = dd["msg"] as! String
                     if(msg == "Your token has expired."){
                        OperationQueue.main.addOperation {
                            //VC.callRefreshTokenFunc()
                            return
                        }
                     }
                 }
             }
            
              // Check if data was received successfully
              if error == nil && data != nil {
                  do {
                      // Convert NSData to Dictionary where keys are of type String, and values are of any type
                     let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                        completionHandler(json, "")
                        
                      //do your stuff
                      
                  } catch {
                    let json : Any = (Any).self
                    completionHandler(json, "")
                  }
              }
              else if error != nil
              {
                let json : Any = (Any).self
                 completionHandler(json, "error")
              }
          }).resume()
          
          
          
      }
    
      
        static func onResponsePostWithToken(url: String, controller: UIViewController ,parms: Any, completion: @escaping (_ res: Any, _ error: String) -> Void) {
            
            
                let configuration = URLSessionConfiguration.default
                let session = URLSession(configuration: configuration)
                let url = NSURL(string:"\(url)")
                let request = NSMutableURLRequest(url: url! as URL)
                request.httpMethod = "POST"
            
              //  if let authToken = userDef.value(forKey: "authToken") {
                    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NjAyODk5ODIsImlhdCI6MTYxNTU3Mjk4NCwiZXhwIjoxNjc4NjQ0OTg0fQ._eOZrum06hEfpeGv9TXZe78xShOB3Dj9fU_V3ghdjpM", forHTTPHeaderField: "x-auth-token")
           // request.setValue("847", forHTTPHeaderField: "version_code")
           // request.setValue("483,674,606,445,165,594,695,489,732,713,389,756,461,374,501,678,619,650,684,653", forHTTPHeaderField: "flagr_variation_ids")
            request.setValue("US", forHTTPHeaderField: "country")
            
            
            
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parms, options: JSONSerialization.WritingOptions())
                    let task = session.dataTask(with: request as URLRequest) {
                        data, response, error in
                        
                        if let httpStatus = response as? HTTPURLResponse,
                            httpStatus.statusCode == 401 { // check for httperrors
                            if let parsedData = try? JSONSerialization.jsonObject(with: data!)
                                {
                                    //Globalfunc.print(object:parsedData)
                                    let dd = parsedData as! NSDictionary
                                    let msg = dd["msg"] as! String
                               
                                    if(msg == "Your token has expired."){
                                        OperationQueue.main.addOperation {
                                          //  VC.callRefreshTokenFunc()
                                            return
                                        }
                                    }
                                }
                        }
                        if error == nil && data != nil{
                            do {
                               let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                                  completion(json, "")
                            }
                            catch {
                              let json : Any = (Any).self
                              completion(json, "Status_Not_200")
                            }
                            }
                        else{
                            let json : Any = (Any).self
                            completion(json, error.debugDescription)
                        }
                        }
                        task.resume()
                    }
                    catch
                    {

                    }
        }
    
    
    
        static func onResponsePutWithToken(url: String, controller: UIViewController ,parms: NSDictionary, completion: @escaping (_ res: Any, _ error: String) -> Void)
        {
                    let configuration = URLSessionConfiguration.default
                    let session = URLSession(configuration: configuration)
                    let url = NSURL(string:"\(url)")
                    let request = NSMutableURLRequest(url: url! as URL)
                    request.httpMethod = "PUT"
                
                    if let authToken = userDef.value(forKey: "authToken") {
                        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                        request.setValue("\(authToken)", forHTTPHeaderField: "Authorization")
                    }


                    do {
                        request.httpBody = try JSONSerialization.data(withJSONObject: parms, options: JSONSerialization.WritingOptions())
                        let task = session.dataTask(with: request as URLRequest) {
                            data, response, error in
                           
                            if let httpStatus = response as? HTTPURLResponse,
                                httpStatus.statusCode == 401 { // check for httperrors
                                if let parsedData = try? JSONSerialization.jsonObject(with: data!)
                                    {
                                       // Globalfunc.print(object:parsedData)
                                        let dd = parsedData as! NSDictionary
                                        let msg = dd["message"] as! String
                                   
                                        if(msg == "Your token has expired."){
                                            OperationQueue.main.addOperation {
                                              //  VC.callRefreshTokenFunc()
                                                return
                                            }
                                        }
                                    }
                            }
                            
                            if error == nil && data != nil{
                                do {
                                   let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                                      completion(json, "")
                                }
                                catch {
                                  let json : Any = (Any).self
                                  completion(json, "Status_Not_200")
                                }
                                }
                            }
                            task.resume()
                    }
                    catch
                    {

                    }
            }
    
    
    
}
