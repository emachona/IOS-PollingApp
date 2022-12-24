//
//  DetailsTableViewCell.swift
//  PollingApp
//
//  Created by Emilija Chona on 12/22/22.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var questionTL: UILabel!
    @IBOutlet weak var startDateTL: UILabel!
    @IBOutlet weak var endDateTL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
