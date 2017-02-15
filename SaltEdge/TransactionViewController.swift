//
//  TransactionViewController.swift
//  SaltEdge
//
//  Created by SureshKumar on 15/02/17.
//  Copyright © 2017 ajira. All rights reserved.
//

import UIKit
import SaltEdge_iOS
import DropDown

class TransactionViewController: UIViewController,UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var toDate: UIDatePicker!
    func toggleTableView(_ sender: UITextField) {
        self.accountsListTableView.isHidden = !self.accountsListTableView.isHidden
    }
    
    @IBOutlet weak var fromDate: UIDatePicker!
    
    @IBOutlet weak var accountListField: UITextField!
    
    var login: Login?

    @IBOutlet weak var accountsListTableView: UITableView!
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("login status",login?.status)
        APIManager.instance.fetchFullAccountsList(forLoginSecret: login?.secret!, success: { (accounts :Set<AnyHashable>?) in
            DispatchQueue.main.async {
                for account in accounts!{
                    self.accountList.append(account.base as! SEAccount)
                }
                let datasource = self.accountList.map({ account in
                    return account.name
                })
                print("dataSource", datasource.count)
                
//                self.dropdown.dataSource = self.accountList.map({ account in
//                    return account.name
//               })
                
            }
                
            
        }) { (error : SEError?) in
            print(error)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count", accountList)
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
    }
    
}
