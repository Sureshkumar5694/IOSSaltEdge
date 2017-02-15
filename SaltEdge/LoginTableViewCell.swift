//
//  LoginTableViewCell.swift
//  SaltEdge
//
//  Created by SureshKumar on 15/02/17.
//  Copyright © 2017 ajira. All rights reserved.
//

import UIKit

class LoginTableViewCell: UITableViewCell {
    
    var data: Login? {
        didSet{
            self.providerName.text = data?.providerName!
        }
    }
    
    @IBOutlet weak var loginId: UILabel!
    
    @IBOutlet weak var providerName: UILabel!
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
