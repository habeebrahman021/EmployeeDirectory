//
//  DataManager.swift
//  EmployeeDirectory
//
//  Created by Habeeb Rahman on 27/11/21.
//

import UIKit
import CoreData
import Alamofire

class DataManager {
    func storeEmployeeList() {
        
    }
    
    func save(employee: Employee){
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
        let managedContext =
        appDelegate.persistentContainer.viewContext
        let entity =
        NSEntityDescription.entity(forEntityName: "EmployeeList",
                                   in: managedContext)!
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        person.setValue(employee.id, forKeyPath: "id")
        person.setValue(employee.username, forKey: "username")
        person.setValue(employee.name, forKeyPath: "name")
        person.setValue(employee.phone, forKey: "phone")
        person.setValue(employee.email, forKeyPath: "email")
        person.setValue(employee.address.street, forKey: "address_street")
        person.setValue(employee.address.suite, forKey: "address_suite")
        person.setValue(employee.address.city, forKey: "address_city")
        person.setValue(employee.address.zipcode, forKey: "address_zip")
        person.setValue(employee.website, forKeyPath: "website")
        person.setValue(employee.profileImage, forKey: "profile_image")
        person.setValue(employee.company?.name, forKey: "company_name")
        person.setValue(employee.company?.catchPhrase, forKeyPath: "company_catch_phase")
        person.setValue(employee.company?.bs, forKey: "company_bs")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchEmployeeList(_ searchQuery: String = "", onCompletion: @escaping(_ success: Bool, _ data: [Employee])->()) {
        var employeeList: [Employee] = []
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
        let managedContext =
        appDelegate.persistentContainer.viewContext
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "EmployeeList")
        if searchQuery != "" {
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS %@ OR email CONTAINS %@", argumentArray: [searchQuery, searchQuery])
        }
        do {
            let empList = try managedContext.fetch(fetchRequest)
            for data in empList {
                let id = (data.value(forKey: "id") as? Int) ?? 0
                let name = (data.value(forKey: "name") as? String) ?? ""
                let username = (data.value(forKey: "username") as? String) ?? ""
                let phone = (data.value(forKey: "phone") as? String) ?? ""
                let email = (data.value(forKey: "email") as? String) ?? ""
                let addressStreet = (data.value(forKey: "address_street") as? String) ?? ""
                let addressSuite = (data.value(forKey: "address_suite") as? String) ?? ""
                let addressCity = (data.value(forKey: "address_city") as? String) ?? ""
                let addressZip = (data.value(forKey: "address_zip") as? String) ?? ""
                let website = (data.value(forKey: "website") as? String) ?? ""
                let profileImage = (data.value(forKey: "profile_image") as? String) ?? ""
                let companyName = (data.value(forKey: "company_name") as? String) ?? ""
                let companyCatchPhase = (data.value(forKey: "company_catch_phase") as? String) ?? ""
                let companyBs = (data.value(forKey: "company_bs") as? String) ?? ""
                let company = Company(name: companyName, catchPhrase: companyCatchPhase, bs: companyBs)
                let address = Address(street: addressStreet, suite: addressSuite, city: addressCity, zipcode: addressZip)
                let employee = Employee(id: id, name: name, username: username, email: email, profileImage: profileImage, address: address, phone: phone, website: website, company: company)
                employeeList.append(employee)
            }
            onCompletion(true, employeeList)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            onCompletion(false, employeeList)
        }
        
    }
    
    func downloadEmployeeList(onCompletion: @escaping(_ success: Bool)->()) {
        AF.request("http://www.mocky.io/v2/5d565297300000680030a986")
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else { return }
                    do {
                        let decoder = JSONDecoder()
                        let employeeListResp = try decoder.decode([Employee].self, from: data)
                        for employee in employeeListResp{
                            DataManager().save(employee: employee)
                        }
                        UserDefaults.standard.set(true, forKey: "isDataLoaded")
                        onCompletion(true)
                    } catch let error {
                        print(error)
                        onCompletion(false)
                    }
                case .failure:
                    onCompletion(false)
                }
                
            }
    }
}
