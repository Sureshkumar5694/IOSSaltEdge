//
//  CategoryTableViewCell.swift
//  SaltEdge
//
//  Created by SureshKumar on 15/02/17.
//  Copyright © 2017 ajira. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    var transaction : Transaction?{
        didSet{
            updateUI()
        }
    }
    @IBOutlet weak var transactionDescription: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    private func updateUI(){
        self.transactionDescription.text = transaction?.description
        self.amount.text = (transaction?.amount.stringValue)! + (transaction?.currencyCode)!
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
