//
//  CategoryTableViewController.swift
//  SaltEdge
//
//  Created by SureshKumar on 15/02/17.
//  Copyright © 2017 ajira. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    var category = [[Transaction]](){
        didSet{
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        tableView.tableFooterView = UIView()
        super.viewDidLoad()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return category.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category[section].count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category cell", for: indexPath)
        
        if let categoryCell = cell as? CategoryTableViewCell{
            categoryCell.transaction =  category[indexPath.section][indexPath.row]
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let transaction: Transaction = category[section][0]
        return transaction.category
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "graph"{
            if let destinationViewController = segue.destination as? CategoryGraphViewController{
                destinationViewController.categories = self.category
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */

}
