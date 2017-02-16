//
//  LoginViewController.swift
//  SaltEdge
//
//  Created by SureshKumar on 10/02/17.
//  Copyright © 2017 ajira. All rights reserved.
//

import UIKit
import SaltEdge_iOS
import SVProgressHUD
import RealmSwift
import Realm
import Alamofire

class LoginViewController: UIViewController, SELoginFetchingDelegate {

    @IBOutlet weak var providersListField: AutoCompleteTextField!
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    var providersList : Array<Provider> = []
    
    var selectedProvider: Provider?
    
    let alert = UIAlertController(title: "Enter Details", message: "", preferredStyle: .alert)
    
    let realm = try! Realm()
   
    @IBAction func createLogin(_ sender: UIButton) {
        SVProgressHUD.show(withStatus: "Creating Login")
        
        let parameters =  ["customer_id": UserDefaults.standard.string(forKey: "customerId"),
                           "country_code": selectedProvider?.country_code,
                           "provider_code": selectedProvider?.code,
                           "credentials": [ "login": userName.text, "password": password.text ]
                          ] as [AnyHashable : Any]
        APIManager.instance.createLogin(withParameters: parameters, success: { (loginObject : SELogin?) in
            self.userName.text = ""
            self.password.text = ""
            self.password.resignFirstResponder()
        }, failure: { (error : SEError?) in
            print(error)
        }, delegate: self)
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        providersListField.maximumAutoCompleteCount = 10
        
        if !UserDefaults.standard.bool(forKey: "isProvidersSynced") {
            syncProviders()
        }
        
        if UserDefaults.standard.bool(forKey: "isProvidersSynced") {
            providersList = Array(realm.objects(Provider.self))
        }
        
        providersListField.onTextChange = {[weak self] text in
            if !text.isEmpty{
                self?.fetchProviders(string: text)
            }

        }
        
        providersListField.onSelect = {[weak self] name, indexpath in
        let predicate = NSPredicate(format: "name = %@", name)
           self?.selectedProvider =  self?.realm.objects(Provider.self).filter(predicate).first
           self?.providersListField.resignFirstResponder()
        }
        
        
    }
    
    private func fetchProviders(string : String){
        let predicate = NSPredicate(format: "name CONTAINS %@", string)
        let filteredProviders = Array(realm.objects(Provider.self).filter(predicate))
        providersListField.autoCompleteStrings =  filteredProviders.map({ provider in
            return provider.name})
    }
    
    private func syncProviders(){
        SVProgressHUD.show()
        APIManager.instance.fetchFullProvidersList(success: { (SEProviders : Set<AnyHashable>?) in
            DispatchQueue.main.async {

                for SEProvider in SEProviders!{
                    if let provider = SEProvider.base as? SEProvider{
                        print("req", provider.requiredFields as! [NSDictionary])
                        print("int", provider.interactiveFields)
                        let provider = Provider(value: ["name": provider.name!,
                                                        "code":provider.code!,
                                                        "mode": provider.mode!,
                                                        "status": provider.status!,
                                                        "instruction": provider.instruction!,
                                                        "home_url": provider.homeUrl!,
                                                        "login_url": provider.loginUrl!,
                                                        "forum_url": provider.forumUrl!,
                                                        "country_code": provider.countryCode!,
                            
                            ])
                        
                        try! self.realm.write {
                            self.realm.add(provider)
                        }
//                        print("realm Url", Realm.Configuration.defaultConfiguration.fileURL!)
                        UserDefaults.standard.set(true, forKey: "isProvidersSynced")
                        
                        self.providersList = Array(self.realm.objects(Provider.self))
                    }
                }
            }
            
            SVProgressHUD.dismiss()
            
        }) { (error : SEError?) in
            print("Error", error)
        }
        
    }
    
    func login(_ login: SELogin, failedToFetchWithMessage message: String) {
        print(message)
        SVProgressHUD.dismiss()
    }
    func loginSuccessfullyFinishedFetching(_ login: SELogin){
        print("Suceesfully logged in", login)
        SVProgressHUD.dismiss()
    }
    
    func loginRequestedInteractiveInput(_ login: SELogin) {
        
        var credentials = [String:String]()
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json",
            "Client-id": "373byI4uTjI0JsAOxIBgAA",
            "Service-secret": "I04_88BgVSKJwbK5k9bc-76mr0-WkOutrucXKZ8_9Z0"
            
        ]
        
        for interativeField in login.interactiveFieldsNames as! [String]{
            self.alert.addTextField(configurationHandler: { (textField : UITextField) in
                textField.placeholder = interativeField
            })
        }
        
        self.alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            for textField in self.alert.textFields!{
                credentials[textField.placeholder!] = textField.text!
            }
            var parameters: Parameters = [
                "data":[
                    "credentials": [
                        "sms": "123456"
                    ]
                ]
            ]
            print("parameters", parameters)
            print("URL", "https://www.saltedge.com/api/v3/logins/\(login.id!)/interactive")
            Alamofire.request("https://www.saltedge.com/api/v3/logins/\(login.id!)/interactive", method: .put,
                              parameters: parameters,encoding: JSONEncoding.default, headers : headers).responseJSON { response in
                                print("response", response.result.value as! [String : Any])
                                
                            }
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show providers"{
//            if let stvc = segue.destination as? SearchTableViewController{
//                stvc.providerList = self.providersList
//            }
        }
        
    }
}
