//
//  MessageTableViewCell.swift
//  localMessenger
//
//  Created by Oleksii Mykhalchuk on 7/14/22.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var bodyReceive: UILabel!
    @IBOutlet weak var stampReceive: UILabel!
    @IBOutlet weak var imageReceive: UIImageView!
    @IBOutlet weak var viewReceive: UIView!

    @IBOutlet weak var bodySend: UILabel!
    @IBOutlet weak var stampSend: UILabel!
    @IBOutlet weak var imageSend: UIImageView!
    @IBOutlet weak var viewSend: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
