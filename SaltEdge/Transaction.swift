//
//  Accounts.swift
//  SaltEdge
//
//  Created by SureshKumar on 15/02/17.
//  Copyright © 2017 ajira. All rights reserved.
//

import Foundation
import SaltEdge_iOS

class Transaction{
    
    var id: NSNumber!
    
    var accountId : NSNumber!
    
    var duplicated: NSNumber!
    
    var mode: String!
    
    var madeOn: Date!
    
    var amount: NSNumber!
    
    var currencyCode: String!
    
    var description: String!
    
    var category: String!
    
    open var createdAt: String!
    
    open var updatedAt: String!
    
    init(data : NSDictionary){
        self.id = data["id"] as! NSNumber
        self.accountId = data["account_id"] as! NSNumber
        self.duplicated = data["duplicated"] as! NSNumber
        self.mode = data["mode"] as! String
        self.amount = data["amount"] as! NSNumber
        self.currencyCode = data["currency_code"] as! String
        self.description = data["description"] as! String
        self.category = data["category"] as! String
        self.createdAt = data["created_at"] as! String
        self.updatedAt = data["updated_at"] as! String
        
    }

}
