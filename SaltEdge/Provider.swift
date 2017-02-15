//
//  Provider.swift
//  SaltEdge
//
//  Created by SureshKumar on 14/02/17.
//  Copyright © 2017 ajira. All rights reserved.
//

import Foundation
import RealmSwift

class Provider: Object {
    
    dynamic var code : String = ""
    dynamic var name : String = ""
    dynamic var mode : String = ""
    dynamic var status: String = ""
    dynamic var instruction: String = ""
    dynamic var home_url: String = ""
    dynamic var login_url: String = ""
    dynamic var forum_url: String = ""
    dynamic var country_code: String = ""
}

