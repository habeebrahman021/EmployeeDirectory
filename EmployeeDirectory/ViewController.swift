//
//  ViewController.swift
//  EmployeeDirectory
//
//  Created by Habeeb Rahman on 27/11/21.
//

import UIKit
import Alamofire
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var employeeListTableView: UITableView!
    
    var employeeList: [Employee] = [Employee]()
    var filteredArray: [Employee] = [Employee]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTableViewCell()
        employeeListTableView.delegate = self
        employeeListTableView.dataSource = self
        searchBar.delegate = self
        let isDataLoaded = UserDefaults.standard.bool(forKey: "isDataLoaded")
        if isDataLoaded {
            fetchData()
        } else {
            downloadData()
        }
    }
    
    func registerTableViewCell() {
        let cellNib = UINib(nibName: "EmployeeListTableViewCell", bundle: nil)
        employeeListTableView.register(cellNib, forCellReuseIdentifier: "EmployeeListTableViewCell")
    }
    
    func downloadData() {
        activityIndicator.startAnimating()
        DataManager().downloadEmployeeList(){ success in
            self.activityIndicator.stopAnimating()
            if success {
                self.fetchData()
            }
        }
    }
    
    func fetchData(_ query: String = "") {
        activityIndicator.startAnimating()
        DataManager().fetchEmployeeList(query){ status, data in
            self.activityIndicator.stopAnimating()
            self.employeeList = data
            self.filteredArray = data
            self.employeeListTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeListTableViewCell", for: indexPath) as! EmployeeListTableViewCell
        cell.setData(employee: filteredArray[indexPath.row])
         return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsVc = storyboard.instantiateViewController(withIdentifier: "EmployeeDetailsViewController") as! EmployeeDetailsViewController
        detailsVc.employee = filteredArray[indexPath.row]
        self.navigationController?.pushViewController(detailsVc, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            self.fetchData(searchText)
        } else {
            self.fetchData()
        }
    }
}

extension UIImageView {
    func loadFromUrl(urlString: String) {
        if urlString == "" {
            return
        }
        if let url = URL(string: urlString) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
            }
        } else {
            return
        }
    }
}
