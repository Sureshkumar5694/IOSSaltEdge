//
//  LoginListTableViewController.swift
//  SaltEdge
//
//  Created by SureshKumar on 15/02/17.
//  Copyright © 2017 ajira. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class LoginListTableViewController: UITableViewController {
    
    var loginList: [Login] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loginList = []
        
        SVProgressHUD.show()
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json",
            "Client-id": "373byI4uTjI0JsAOxIBgAA",
            "Service-secret": "I04_88BgVSKJwbK5k9bc-76mr0-WkOutrucXKZ8_9Z0"
            
        ]
        Alamofire.request("https://www.saltedge.com/api/v3/logins?customer_id=\(UserDefaults.standard.integer(forKey: "Id"))", headers: headers).responseJSON { response in
            let response = response.result.value as! [String : Any]
            let data = response["data"] as! [NSDictionary]
            DispatchQueue.main.async {
                for login in data{
                    self.loginList.append(Login(data : login))
                }
                SVProgressHUD.dismiss()
            }
            
        }
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loginList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "login", for: indexPath)

        if let loginCell = cell as? LoginTableViewCell{
            loginCell.data = loginList[indexPath.row]
        }

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "transaction segue"{
            let destinationViewController = segue.destination as? TransactionViewController
             destinationViewController?.login = loginList[(tableView.indexPathForSelectedRow?.row)!]
                
            }
        }

    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


