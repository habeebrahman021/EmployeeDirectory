//
//  EmployeeDetailsViewController.swift
//  EmployeeDirectory
//
//  Created by Habeeb Rahman on 27/11/21.
//

import UIKit

class EmployeeDetailsViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    var employee: Employee? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.clipsToBounds = true
        setEmployeeData()
    }
    
    func setEmployeeData() {
        if let data = self.employee {
            self.title = data.name
            nameLabel.text = data.name
            userNameLabel.text = data.username
            emailLabel.text = data.email
            phoneLabel.text = data.phone
            websiteLabel.text = data.website
            addressLabel.text = "\(data.address.street), \(data.address.suite), \(data.address.city), \(data.address.zipcode)"
            if let company = data.company {
                companyLabel.text = "\(company.name)\n\(company.catchPhrase)\n\(company.bs)"
            }
            if let imageUrl = data.profileImage {
                if imageUrl != "" {}
                profileImageView.loadFromUrl(urlString: imageUrl)
            } else {
                profileImageView.image = UIImage(named: "placeholder")
            }
            
        }
    }
    
}
