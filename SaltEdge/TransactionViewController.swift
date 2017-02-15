//
//  TransactionViewController.swift
//  SaltEdge
//
//  Created by SureshKumar on 15/02/17.
//  Copyright © 2017 ajira. All rights reserved.
//

import UIKit
import SaltEdge_iOS
import Alamofire

class TransactionViewController: UIViewController,UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var toDate: UIDatePicker!
    func toggleTableView(_ sender: UITextField) {
        self.accountsListTableView.isHidden = !self.accountsListTableView.isHidden
    }
    
    @IBOutlet weak var fromDate: UIDatePicker!
    
    @IBOutlet weak var accountListField: UITextField!
    
    var login: Login?
    
    var selectedAccount: SEAccount?
    
    var transactionsList: [Transaction] = []
    
    var categorisedTransaction = [[Transaction]]()
    

    @IBOutlet weak var accountsListTableView: UITableView!
    
    @IBAction func viewTransaction(_ sender: Any) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json",
            "Client-id": "373byI4uTjI0JsAOxIBgAA",
            "Service-secret": "I04_88BgVSKJwbK5k9bc-76mr0-WkOutrucXKZ8_9Z0"
            
        ]
        
        let parameters: Parameters = ["account_id": selectedAccount?.id! , "from_date": fromDate.date, "to_date": toDate.date]
        
        Alamofire.request("https://www.saltedge.com/api/v3/transactions", parameters: parameters, headers: headers).responseJSON { response in
            DispatchQueue.main.async {
                if let transactions = response.result.value as? [String: Any] {
                    for transaction in transactions["data"] as! [NSDictionary]{
                        self.transactionsList.append(Transaction(data: transaction))
                    }
                    self.categorisedTransaction =  self.transactionsList.groupBy { $0.category }
                    self.performSegue(withIdentifier: "category", sender: self)
                    
                }

            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? CategoryTableViewController{
            destinationViewController.category = self.categorisedTransaction
        }
    }
    
    var accountList : [SEAccount] = []{
        didSet{
            accountsListTableView.reloadData()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.accountsListTableView.delegate = self
        self.accountsListTableView.dataSource = self
        self.accountsListTableView.isHidden = true
        accountListField.addTarget(self, action: "toggleTableView:", for: UIControlEvents.touchDown)

    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        print("login status",login?.status)
        self.transactionsList = []
        APIManager.instance.fetchFullAccountsList(forLoginSecret: login?.secret!, success: { (accounts :Set<AnyHashable>?) in
            DispatchQueue.main.async {
                self.accountList = []
                for account in accounts!{
                    self.accountList.append(account.base as! SEAccount)
                }
            }
            
        }) { (error : SEError?) in
            print(error)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = accountList[indexPath.row].name!
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        accountListField.text = accountList[indexPath.row].name!
        self.accountsListTableView.isHidden = true
        selectedAccount = accountList[indexPath.row]
    }
    
}

extension Array {
    func groupBy<G: Hashable>(groupClosure: (Element) -> G) -> [[Element]] {
        var groups = [[Element]]()
        
        for element in self {
            let key = groupClosure(element)
            var active = Int()
            var isNewGroup = true
            var array = [Element]()
            
            for (index, group) in groups.enumerated() {
                let firstKey = groupClosure(group[0])
                if firstKey == key {
                    array = group
                    active = index
                    isNewGroup = false
                    break
                }
            }
            
            array.append(element)
            
            if isNewGroup {
                groups.append(array)
            } else {
                groups.remove(at: active)
                groups.insert(array, at: active)
            }
        }
        
        return groups
    }
}
