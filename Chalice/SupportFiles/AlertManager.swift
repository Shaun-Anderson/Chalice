//
//  AlertManager.swift
//  Chalice
//
//  Created by Shaun Anderson on 20/8/18.
//  Copyright © 2018 Shaun Anderson. All rights reserved.
//

import Foundation
import UIKit

class AlertManager {
    
    static func confirmAlert(title:String, message:String, ok:String, cancel:String, okHandler:@escaping (UIAlertAction?, UIAlertController) -> Void) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: ok, style: .default) { action in
            okHandler(action, alert)
        }
        let cancelAction = UIAlertAction(title: cancel,
                                         style: .cancel) { (action: UIAlertAction!) -> Void in
                                            
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        return alert
    }
    
    
    
}
