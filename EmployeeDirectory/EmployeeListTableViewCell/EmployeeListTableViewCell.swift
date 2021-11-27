//
//  EmployeeListTableViewCell.swift
//  EmployeeDirectory
//
//  Created by Habeeb Rahman on 27/11/21.
//

import UIKit

class EmployeeListTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(employee: Employee) {
        employeeNameLabel.text = employee.name
        companyNameLabel.text = employee.company?.name
        if let imageUrl = employee.profileImage {
            if imageUrl != "" {}
            profileImageView.loadFromUrl(urlString: imageUrl)
        } else {
            profileImageView.image = UIImage(named: "placeholder")
        }
        
    }
    
}
