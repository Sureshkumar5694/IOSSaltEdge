//
//  Login.swift
//  SaltEdge
//
//  Created by SureshKumar on 14/02/17.
//  Copyright © 2017 ajira. All rights reserved.
//

import Foundation

class Login{
    
    var id: NSNumber!
    
    var secret: String!
        
    var providerCode: String!
    
    var providerName: String!
    
    var createdAt: String!
    
    var updatedAt: String!
    
    var lastRequestAt: Date!
    
    var status: String!
    
    var countryCode: String!
    
    init(data : NSDictionary){
        self.id = data["id"] as! NSNumber
        self.secret = data["secret"] as! String
        self.providerCode = data["provider_code"] as! String
        self.providerName = data["provider_name"] as! String
        self.status = data["status"] as! String
        self.countryCode = data["country_code"] as! String
        self.createdAt =  data["created_at"] as! String
        self.updatedAt =  data["updated_at"] as! String
    }

}
