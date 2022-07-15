//
//  UserTableViewCell.swift
//  localMessenger
//
//  Created by Oleksii Mykhalchuk on 7/15/22.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var timeName: UILabel!
    @IBOutlet weak var viewMessage: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
