//
//  ViewController.swift
//  SaltEdge
//
//  Created by SureshKumar on 09/02/17.
//  Copyright © 2017 ajira. All rights reserved.
//

import UIKit
import SaltEdge_iOS
import CoreFoundation

class ViewController: UIViewController {
    
    let manager = APIManager.instance
    
    @IBOutlet weak var userName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func createCustomer(_ sender: UIButton) {
        manager.createCustomer(withIdentifier: userName.text,
                               success: { (result: [AnyHashable : Any]?) in
                                let customerDetails = result?["data"] as! NSDictionary
                                UserDefaults.standard.set(customerDetails["customer_id"] as! String, forKey: "customerId")
                                UserDefaults.standard.set(customerDetails["id"] as! Int, forKey: "Id")
                                DispatchQueue.main.async {
                                  self.performSegue(withIdentifier: "login segue", sender: self)
                                }
                                
        }) { (error : SEError?) in
            print("Error",error )
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login segue"{
//            if let navigationController = segue.destination as? UINavigationController{
//                if let targetController = navigationController.topViewController as? LoginViewController{
//                    
//                }
//            }
            
        }
    }
        
    


}

